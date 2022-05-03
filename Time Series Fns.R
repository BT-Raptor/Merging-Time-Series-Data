require(data.table)
require(lubridate)

Resample=function(df,time_frame,date_col){
  #This function takes a dataframe, and a string that states how you want to resample, and another string that says where the date column in question is.
  #and then resamples the dataframe based on your criteria.
  
  #df: the dataframe you want resampled
  #time_frame: how you want the resampling to happen: end of the month, or end of the week (Business Day)
  #date_col: this is the datecolumn you want this function working on
  
  setDT(df)
  df[,(date_col):=as.Date(get(date_col))]
  df=df[order(df[[date_col]],decreasing = TRUE),]
  
  if(time_frame=='M'){
    df[,(date_col):=ceiling_date(as.Date(get(date_col)),'month')-1]
  }
  
  if(time_frame=='W'){
    df[,(date_col):=ceiling_date(as.Date(get(date_col)),'weekly')-2]
  }
  
  df=unique(df,by=c(date_col))
  
  df=df[order(df[[date_col]],decreasing = FALSE),]
  return(df)
}

Rolling_Merge=function(df1,df2,merge_col){
  #This function takes two dataframes and a string indicating on which column the merge happens on, and then it conducts a simple forward filled rolling join
  
  #df1: the first dataframe that will be used
  #df2: the second dataframe that will be left joined to the first one
  #merge_col: this is the column you will be using for your merges.
  
  setDT(df1)
  setDT(df2)
  df1[,(merge_col):=as.Date(get(merge_col))]
  df2[,(merge_col):=as.Date(get(merge_col))]
  
  other_cols=c((names(df2)))
  cols_to_apply_to=other_cols[!other_cols == merge_col]
  
  new_df=merge(df1,df2,by=c(merge_col),all.x=T)
  new_df[ , (cols_to_apply_to) := lapply(.SD, function(x){nafill(x,'locf')}), .SDcols = cols_to_apply_to]
  return(new_df)
}

