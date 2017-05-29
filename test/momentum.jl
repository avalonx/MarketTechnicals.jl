facts("Momentum") do

    context("rsi") do
        @fact rsi(cl).values[end]              --> roughly(55.849, atol=.01) # TTR value is 55.84922
        @fact rsi(cl, wilder=true).values[end] --> roughly(55.959, atol=.01) # TTR value is 55.95932
        @fact rsi(cl, 10).values[end]          --> roughly(56.219, atol=.01) # TTR value is 56.21947
        @fact rsi(ohlc).values[end,:]          --> roughly([68.030, 61.872, 70.062, 55.849], atol=.01)

        # seed is included (TODO: debate amongst yourselves)
        @fact rsi(cl).timestamp[1]              --> Date(2000,1,21)
        @fact rsi(cl, wilder=true).timestamp[1] --> Date(2000,1,21)
        @fact rsi(cl, 10).timestamp[1]          --> Date(2000,1,14)
        @fact rsi(ohlc).timestamp[1]            --> Date(2000,1,21)

        @fact rsi(cl).timestamp[end]              --> Date(2001,12,31)
        @fact rsi(cl, wilder=true).timestamp[end] --> Date(2001,12,31)
        @fact rsi(cl, 10).timestamp[end]          --> Date(2001,12,31)
        @fact rsi(ohlc).timestamp[end]            --> Date(2001,12,31)
    end

    context("macd") do
        @fact macd(cl).values[end, 1] --> roughly(-0.020, atol=.01)
        @fact macd(cl).values[end, 2] --> roughly(0.421, atol=.01) # TTR value with percent=FALSE is 0.421175152
        @fact macd(cl).values[end, 3] --> roughly(0.441, atol=.01) # TTR value with percent=FALSE is 0.4414275
        @fact macd(cl).timestamp[end] --> Date(2001,12,31)
    end

    context("macd multi-column TimeArray") do
        # multi-column TimeArray
        # TTR: MACD(..., maType="EMA", percent=0)
        ta = macd(ohlc["Open", "Close"])
        @fact ta.colnames[1:2]        --> ["Open_macd", "Close_macd"]
        @fact ta.values[end, 3]       --> roughly(0.44254569, atol=.01)    # Open_dif
        @fact ta.values[end, 5]       --> roughly(4.536854e-01, atol=.01)  # Open_signal
        @fact ta.values[end, 4]       --> roughly(0.421175152, atol=.01)   # Close_dif
        @fact ta.values[end, 6]       --> roughly(4.414275e-01, atol=.01)  # Close_signal
        @fact ta.timestamp[end]       --> Date(2001, 12, 31)
    end

    context("chaikin_osc") do
        """
        Quote from TTR

        > EMA(adl, 3) - EMA(adl, 10)
         [1]            NA            NA            NA            NA            NA
         [6]            NA            NA            NA            NA  -6851466.867
        [11]  -5508824.158  -4145747.583  -8413321.022 -10025864.828 -10655603.670
        [16]  -8761003.151  -8025814.774  -6995436.368  -6906221.064  -4303730.935
        [21]  -3660985.797  -3451576.257  -2336638.695  -1217362.729    546925.363
        [26]   1788691.016   1349030.229   1738675.716   1239751.751   1946952.206
        [31]   2893048.890   2658896.120   2715328.628   1937437.546   1910085.631
        [36]   2145262.005   1978248.295   1075784.464   1048400.357    814497.124
        [41]   2914695.065   2944188.520   3555908.642   3085073.413   2268377.529
        [46]   1942893.354   1778694.035   1810347.568   1241765.961   -261885.061
        [51]  -1237656.884   -576205.604    613370.430    649457.675   1738353.505
        [56]   3591576.201   2828408.458   1949186.773   1159350.740    626861.789
        [61]    183217.498  -1132617.797   -712700.508   -691386.657    -57610.324
        [66]    774998.562    561961.806   1084391.707    634202.420   -523959.226
        [71]  -1968845.762  -2496129.556  -3167709.694  -2000329.427   -230334.824
        [76]   -577397.260  -1747313.599   -806782.684    617588.662    443152.062
        [81]   1214832.531   1341044.310   1592063.283    936678.383    186056.580
        [86]  -1209996.220  -1516911.058  -1995687.520  -2776094.760  -4090715.405
        """
        ta = chaikin_osc(ohlcv)
        @fact ta.colnames          --> ["chaikin_osc"]
        @fact ta.meta              --> ta.meta
        @fact ta.values[1]         --> roughly(-6851466.867, atol=.01)
        @fact ta.values[2]         --> roughly(-5508824.158, atol=.01)
        @fact ta.values[3]         --> roughly(-4145747.583, atol=.01)
        @fact ta.timestamp[1]      --> ohlcv.timestamp[10]
    end

    context("cci") do
        # TTR::CCI value is -38.931614
        @fact cci(ohlc).values[1]      --> roughly(-38.931614, atol=.01)
        # TTR::CCI value is 46.3511339
        @fact cci(ohlc).values[end]    --> roughly(46.3511339, atol=.01)
        @fact cci(ohlc).timestamp[end] --> Date(2001, 12, 31)
    end

    context("roc") do
        ta = roc(cl, 3)
        @fact ta.colnames      --> ["Close_roc_3"]
        @fact ta.values[1]     --> roughly(-0.15133107021618722, atol=.01)
        @fact ta.values[2]     --> roughly(-0.02926829268292683, atol=.01)
        @fact ta.values[3]     --> roughly(-0.06009615384615385, atol=.01)
    end
end
