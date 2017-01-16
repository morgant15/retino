# analyze two sessions and see if the parameters correlate
require(plyr)
require(dplyr)
require(ggplot2)
require(quickpsy)

load_data <- function(subject_id) {
    fns <- Sys.glob(paste('../res/', subject_id, '/*.csv', sep=''))
    
    df <- ldply(fns, read.csv)
    df$pos <- as.factor(df$pos)
    df$resp <- ifelse(df$response == 'LeftArrow', 0, 1)
    df$subj_id <- subject_id
    
    return(df)
}

subj <- 'sg'
# first session
df <- load_data(paste(subj, '00', sep=''))
m_quickpsy <- quickpsy(df, morph, resp, grouping=.(pos))

# second session
df1 <- load_data(paste(subj, '01', sep=''))
m_quickpsy1 <- quickpsy(df1, morph, resp, grouping=.(pos))

plotcurves(m_quickpsy, thresholds=F, ci=F)
plotcurves(m_quickpsy1, thresholds=F, ci=F)


# plot correlation of parameters in different sessions
which_param <- 'p1'
param <- m_quickpsy$par %>% filter(parn == which_param) %>% 
    select(pos, parn, par) %>%
    rename(par0=par)
param1 <- m_quickpsy1$par %>% filter(parn == which_param) %>% 
    select(pos, parn, par) %>%
    rename(par1=par)
params <- merge(param, param1)

param_bs <- m_quickpsy$parbootstrap %>% filter(parn == which_param) %>% 
    select(pos, parn, par) %>%
    rename(par0=par)
param1_bs <- m_quickpsy1$parbootstrap %>% filter(parn == which_param) %>% 
    select(pos, parn, par) %>%
    rename(par1=par)
params_bs <- merge(param_bs, param1_bs)

# NOTE: I can use m_quickpsy$parbootstrap to obtain cis
ggplot(params, aes(par0, par1)) + 
    #geom_smooth(data=params_bs, 
    #            method='lm',
    #            aes(group=sample), 
    #            color='gray', alpha=0.5, size=0.3, se=F) +
    geom_smooth(method='lm', color='black', se=F) +
    geom_point(aes(color=pos))

