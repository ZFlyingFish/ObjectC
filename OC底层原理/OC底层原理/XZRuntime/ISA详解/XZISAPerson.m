//
//  XZISAPerson.m
//  OC底层原理
//
//  Created by 毛 on 2021/3/8.
//




#import "XZISAPerson.h"

#define MJTallMask (1<<0)       // 0b0001   1   2^0
#define MJRichMask (1<<1)       // 0b0010   2   2^1
#define MJHandsomeMask (1<<2)   // 0b0100   4   2^2
#define MJThinMask (1<<3)       // 0b1000   8   2^3
  
@interface XZISAPerson ()
{
    union {
        int bits;
        
        struct {
            char tall : 4;
            char rich : 4;
            char handsome : 4;
            char thin : 4;
        };
    } _tallRichHandsome;
}

@end

/**
 
 0b1011
&0b0100
-------
 0b0000
 
 & 与运算 只要有一个不唯1 则取0
 |  或运算 只要有一个唯1     则取1
 
 ~  每一位都取反
 ！取反
 */

@implementation XZISAPerson

- (void)setTall:(BOOL)tall
{
    if (tall) {
        _tallRichHandsome.bits |= MJTallMask;
    } else {
        _tallRichHandsome.bits &= ~MJTallMask;
    }
}

- (BOOL)isTall
{
    return !!(_tallRichHandsome.bits & MJTallMask);
}

- (void)setRich:(BOOL)rich
{
    if (rich) {
        _tallRichHandsome.bits |= MJRichMask;
    } else {
        _tallRichHandsome.bits &= ~MJRichMask;
    }
}

- (BOOL)isRich
{
    return !!(_tallRichHandsome.bits & MJRichMask);
}

- (void)setHandsome:(BOOL)handsome
{
    if (handsome) {
        _tallRichHandsome.bits |= MJHandsomeMask;
    } else {
        _tallRichHandsome.bits &= ~MJHandsomeMask;
    }
}

- (BOOL)isHandsome
{
    return !!(_tallRichHandsome.bits & MJHandsomeMask);
}



- (void)setThin:(BOOL)thin
{
    if (thin) {
        _tallRichHandsome.bits |= MJThinMask;
    } else {
        _tallRichHandsome.bits &= ~MJThinMask;
    }
}

- (BOOL)isThin
{
    return !!(_tallRichHandsome.bits & MJThinMask);
}

@end
