//
// Created by blackmilk on 13-7-19.
//
// 
//



#define BM_LOG_LEVEL_DEBUG      4
#define BM_LOG_LEVEL_INFO       3
#define BM_LOG_LEVEL_WARN       2
#define BM_LOG_LEVEL_ERROR      1

#define BM_ENABLE_LOG
#define BM_LOG_LEVEL    BM_LOG_LEVEL_DEBUG

#ifdef  BM_ENABLE_LOG

#if(BM_LOG_LEVEL >= BM_LOG_LEVEL_DEBUG)
#define BM_LOG_D(format,...)        NSLog((@"BM_DEBUG " format),##__VA_ARGS__)
#else
#define BM_LOG_D(format,...)        do { } while (0)
#endif

#if(BM_LOG_LEVEL >= BM_LOG_LEVEL_INFO)
#define BM_LOG_I(format,...)        NSLog((@"BM_INFO " format),##__VA_ARGS__)
#else
#define BM_LOG_I(format,...)        do { } while (0)
#endif

#if(BM_LOG_LEVEL >= BM_LOG_LEVEL_WARN)
#define BM_LOG_W(format,...)        NSLog((@"BM_WARN " format),##__VA_ARGS__)
#else
#define BM_LOG_W(format,...)        do { } while (0)
#endif


#if(BM_LOG_LEVEL >= BM_LOG_LEVEL_ERROR)
#define BM_LOG_E(format,...)        NSLog((@"BM_ERROR " format),##__VA_ARGS__)
#else
#define BM_LOG_E(format,...)        do { } while (0)
#endif

#else

#define BM_LOG_D(format,...)        do { } while (0)
#define BM_LOG_I(format,...)        do { } while (0)
#define BM_LOG_W(format,...)        do { } while (0)
#define BM_LOG_E(format,...)        do { } while (0)

#endif