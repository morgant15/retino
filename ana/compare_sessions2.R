# analyze two sessions and see if the parameters correlate
require(plyr)
require(dplyr)
require(ggplot2)
require(rlm)

load_data <- function(subject_id) {
    fns <- Sys.glob(paste('../res/', subject_id, '/*.csv', sep=''))
    
    df <- ldply(fns, read.csv)
    df$pos <- as.factor(df$pos)
    df$resp <- ifelse(df$response == 'LeftArrow', 0, 1)
    df$subj_id <- subject_id
    
    return(df)
}


fit_model_predict <- function(df) {
    m <- glm(resp ~ pos + morph - 1, data=df, family=binomial(link='logit'))
    newdata <- expand.grid(pos=unique(df$pos), morph=seq(0, 100, 1))
    newdata$pred <- predict(m, newdata=newdata, type='response')
    newdata$pos <- factor(newdata$pos, levels=levels(newdata$pos), 
                          labels=seq(0, 359, 45))
    return(list(m, newdata))
}

compute_pse <- function(m) {
    coefs <- coef(m)
    pse = abs(coefs/coefs[9])[1:8]
    pse <- data.frame(pse=pse)
    pse$pos <- as.factor(seq(0, 359, 45))
    return(pse)
}


plot_curves <- function(newdata, pse) {
    p <-
ggplot(newdata, aes(morph, pred, color=pos)) + 
    geom_segment(data=pse, aes(x=pse, xend=pse, y=-1, yend=0.5), alpha=0.7) +
    geom_line() +
    theme_bw() +
    scale_x_continuous(breaks=c(0, 17, 33, 50, 67, 83, 100)) +
    theme(panel.grid.major=element_blank(),
          panel.grid.minor=element_blank()) +
    coord_cartesian(ylim=c(0, 1)) +
    labs(x='Percentage morphing to second identity', 
         y='Proportion of responses to second identity',
         color='Angular location')
return(p)
}


plot_deviation <- function(pse) {
    p <-
    ggplot(pse, aes(pos, pse - 50)) + geom_bar(stat='identity') +
    theme_bw() +
    labs(x='Angular location', 
         y='Deviation from 50% PSE') +
    theme(panel.grid.major.x=element_blank(),
          panel.grid.minor.x=element_blank(),
          panel.grid.minor.y=element_blank()) +
    scale_y_continuous(breaks=seq(-25, 25, 5))
    
    return(p)
    }

subj <- c('sg00', 'sg01', 'mv00', 'mv01')

pses <- list()

for (s in subj) {
    df <- load_data(s)
    
    m_newdata <- fit_model_predict(df)
    m <- m_newdata[[1]]
    newdata <- m_newdata[[2]]
    pse <- compute_pse(m)
    
    ggsave(paste('img2/', s, '_curves.pdf', sep=''),
           plot_curves(newdata, pse), w=7.5, h=6)
    ggsave(paste('img2/', s, '_deviation.pdf', sep=''),
           plot_deviation(pse), w=7.5, h=6)
    
    pses[s] <- pse
}

# combine pses in a dataframe
df_pses <- data.frame(ses1=c(pses$sg00, pses$mv00),
                      ses2=c(pses$sg01, pses$mv01),
                      subid=c(rep('sg', 8), rep('mv', 8)),
                      pos=as.factor(rep(seq(0, 359, 45), 2)))

comp_ses <- 
ggplot(df_pses, aes(ses1, ses2, color=as.factor(pos), shape=subid)) +
    geom_smooth(aes(group=1), method='lm', se=F, color='black', alpha=0.8) +
    geom_point(size=4) +
    labs(x='First Measurement [PSE]', y='Second Measurement [PSE]',
         shape='Subject',
         color='Angular location') +
    theme_bw() +
    theme(panel.grid.major=element_blank(),
          panel.grid.minor=element_blank())
    
ggsave(paste('img2/', 'compare_sessions.pdf', sep=''),
       comp_ses, w=7.5, h=6)

