import pandas as pd
import numpy as np
from pandas.tseries.offsets import *


def Resample(df,time_frame,date_col):
    # This function takes a dataframe, and a string that states how you want to resample, and another string that says where the date column in question is.
    # and then resamples the dataframe based on your criteria.

    # df: the dataframe you want resampled
    # time_frame: how you want the resampling to happen: end of the month, or end of the week (Business Day)
    # date_col: this is the datecolumn you want this function working on
    df[date_col]=pd.to_datetime(df[date_col])
    df=df.sort_values(by=date_col, ascending=False)
    if time_frame=='M':
        df[date_col] = df[date_col] + MonthEnd(1)
    if time_frame=='W':
        df[date_col] = df[date_col] + Week(weekday=4)

    df=df.drop_duplicates(subset=date_col)
    return df

def Rolling_Merge(df1,df2,merge_col):
    # This function takes two dataframes and a string indicating on which column the merge happens on, and then it conducts a simple forward filled rolling join

    # df1: the first dataframe that will be used
    # df2: the second dataframe that will be left joined to the first one
    # merge_col: this is the column you will be using for your merges.
    df1[merge_col]=pd.to_datetime(df1[merge_col])
    df2[merge_col]=pd.to_datetime(df2[merge_col])

    merged_data = df1.merge(df2, on=merge_col, how='left').fillna(method='ffill')
    return merged_data
