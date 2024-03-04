// ****************************************************************************
//  ViewController.mm                                             DB48X project
// ****************************************************************************
//
//   File Description:
//
//     View controller for the DB48X application
//
//
//
//
//
//
//
//
// ****************************************************************************
//   (C) 2024 Christophe de Dinechin <christophe@dinechin.org>
//   This software is licensed under the terms outlined in LICENSE.txt
// ****************************************************************************
//   This file is part of DB48X.
//
//   DB48X is free software: you can redistribute it and/or modify
//   it under the terms outlined in the LICENSE.txt file
//
//   DB48X is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// ****************************************************************************

#import "ViewController.h"
#import "Screen.hpp"
#import "Keyboard.hpp"


@interface ViewController ()
// ----------------------------------------------------------------------------
//    The view controller sets up the various elements
// ----------------------------------------------------------------------------
{
    Screen             screen;
    Keyboard           keyboard;
}
@end

struct mousemap
{
    int key, keynum;
    float left, right, top, bot;
} mouseMap[] = {

    { 1,        38, 0.03, 0.15, 0.03, 0.10 },
    { 2,        39, 0.20, 0.32, 0.03, 0.10 },
    { 3,        40, 0.345, 0.47, 0.03, 0.10 },
    { 4,        41, 0.52, 0.63, 0.03, 0.10 },
    { 5,        42, 0.68, 0.80, 0.03, 0.10 },
    { 6,        43, 0.83, 0.95, 0.03, 0.10 },

    { 'a',       1, 0.03, 0.15, 0.15, 0.22 },
    { 'b',       2, 0.20, 0.32, 0.15, 0.22 },
    { 'c',       3, 0.345, 0.47, 0.15, 0.22 },
    { 'd',       4, 0.52, 0.63, 0.15, 0.22 },
    { 'e',       5, 0.68, 0.80, 0.15, 0.22 },
    { 'f',       6, 0.83, 0.95, 0.15, 0.22 },

    { 'g',       7, 0.03, 0.15, 0.275, 0.345 },
    { 'h',       8, 0.20, 0.32, 0.275, 0.345 },
    { 'i',       9, 0.345, 0.47, 0.275, 0.345 },
    { 'j',      10, 0.52, 0.63, 0.275, 0.345 },
    { 'k',      11, 0.68, 0.80, 0.275, 0.345 },
    { 'l',      12, 0.83, 0.95, 0.275, 0.345 },

    { '\n',     13, 0.03, 0.32, 0.40, 0.47 },
    { 'm',      14, 0.345, 0.47, 0.40, 0.47 },
    { 'n',      15, 0.51, 0.64, 0.40, 0.47 },
    { 'o',      16, 0.68, 0.80, 0.40, 0.47 },
    { 8,        17, 0.83, 0.95, 0.40, 0.47 },

    { 10,       18, 0.03, 0.15, 0.52, 0.59 },
    { '7',      19, 0.23, 0.36, 0.52, 0.59 },
    { '8',      20, 0.42, 0.56, 0.52, 0.59 },
    { '9',      21, 0.62, 0.75, 0.52, 0.59 },
    { '/',      22, 0.81, 0.95, 0.52, 0.59 },

    { 11,       23, 0.03, 0.15, 0.645, 0.715 },
    { '4',      24, 0.23, 0.36, 0.645, 0.715 },
    { '5',      25, 0.42, 0.56, 0.645, 0.715 },
    { '6',      26, 0.62, 0.75, 0.645, 0.715 },
    { '*',      27, 0.81, 0.95, 0.645, 0.715 },

    { '^',      28, 0.028, 0.145, 0.77, 0.84 },
    { '1',      29, 0.23, 0.36, 0.77, 0.84 },
    { '2',      30, 0.42, 0.56, 0.77, 0.84 },
    { '3',      31, 0.62, 0.75, 0.77, 0.84 },
    { '-',      32, 0.81, 0.95, 0.77, 0.84 },

    { '\e',     33, 0.03, 0.15, 0.89, 0.97 },
    { '0',      34, 0.23, 0.36, 0.89, 0.97 },
    { '.',      35, 0.42, 0.55, 0.89, 0.97 },
    { '?',      36, 0.62, 0.74, 0.89, 0.97 },
    { '+',      37, 0.81, 0.95, 0.89, 0.97 },

    { 0,  0,      0.0,      0.0,      0.0,      0.0}
};

extern "C" void program_main();


@implementation ViewController

- (void)viewDidLoad
// ----------------------------------------------------------------------------
//   Setup after loading the view
// ----------------------------------------------------------------------------
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
            program_main();
        });

}


-(void) refreshScreen
// ----------------------------------------------------------------------------
//  Refresh the screen
// ----------------------------------------------------------------------------
{
    UIImage *image = [screenView imageFromLCD];
    screenView.image = image;
}

- (IBAction)keyboardWasTapped:(UITapGestureRecognizer *)sender
// ----------------------------------------------------------------------------
//   Tap event on the keyboard
// ----------------------------------------------------------------------------
{
    CGPoint pos = [sender locationInView:keyboardView];
    NSLog(@"Position was %f, %f", pos.x, pos.y);

    CGFloat relx = pos.x / keyboardView.frame.size.width;
    CGFloat rely = pos.y / keyboardView.frame.size.height;

    for (mousemap *ptr = mouseMap; ptr->key; ptr++)
    {
        if ((relx >= ptr->left) && (relx <= ptr->right) &&
            (rely >= ptr->top) && (rely <= ptr->bot))
        {
            NSLog(@"Found key %d", ptr->keynum);
        }
    }

    [self refreshScreen];
}


- (void) pressesBegan:(NSSet<UIPress *> *)presses
            withEvent:(UIPressesEvent *)event
// ----------------------------------------------------------------------------
//   Physical key being pressed
// ----------------------------------------------------------------------------
{
    NSLog(@"Physical keyboard got ");
    for(UIPress* press in presses) {
        UIKey *key = press.key;
        if (!key)
            continue;
        NSString *chars = key.charactersIgnoringModifiers;
        NSLog(@"Got keys %@", chars);
    }
}

- (void)didReceiveMemoryWarning
// ----------------------------------------------------------------------------
//   Low memory: Dispose of resources that can be recreated
// ----------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
