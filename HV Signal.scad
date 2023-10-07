/**
 * @file HV Signal.scad
 * @author Dirk Broßwick (dirk.brosswick@googlemail.com)
 * @version 0.1
 * @date 2023-08-17
 * 
 * @copyright Copyright (c) 2023
 */
// setup the hight in mm
MastHight = 40; //[25:120]
// setup the width in 1/10 mm
MastWidth = 43; //[25:90]
// wall tickness in 1/10mm
WallTickness = 4; //[3:15]
// mast foot radius in 1/10mm
MastFoot = 28; // [10:80]
// mast foot radius in 1/10mm
MastFootLength = 10; // [5:35]
// numbers of  mast knot sheets
MastKnotSheet = 14; // [5:25]
// mast knot ratio in percent
MastKnotRatio = 65; // [10:90]
// number of mast crampons
MastCrampons = 7; // [3:25]
// H/V Signal Type (DB)
SignalType=6; // [1:Blocksignal, 3:Einfahrsignal, 4:Hauptsignal, 6:Ausfahrsignal]
// H/V Extended Signal Type (DB)
SubSignalType=0; // [0:none, 1:Zs1, 2:Zs2, 6:"Zs2 + Zs3"]
// LED type
LedType = 1;// [0:"0603",1:"0805",2:"1206",3:"3528",4:"5050"]
// show LED
ShowLed = 0; // [0:no,1:yes]
// generate a helping hand for assembly the blende
HelpingHand = false;

if( HelpingHand == true ) {
    translate( [0,0,0] ) rotate( [90,0,0]) helper_blende(  MastWidth/5 + 0.4,MastWidth/2.5 + 0.4, WallTickness/10 , MastWidth/2/10,MastWidth/10,WallTickness/10 );
}
else {
    translate( [0,0,0] ) color("lightgreen",1.0) mast_typ1( MastWidth/2/10,MastWidth/10,MastHight, WallTickness/10,MastFoot/10);
    translate( [MastWidth/1.3,0,0] ) rotate( [35,0,180] )  blende_back(  MastWidth/5,MastWidth/2.5, WallTickness/10 , MastWidth/2/10,MastWidth/10,WallTickness/10 );

    if( SignalType == 1 ) {
        translate( [MastWidth/4,0,0] ) rotate( [-35,0,0] ) blende_typ1( MastWidth/5, MastWidth/2.5, WallTickness/5, ShowLed );
    }
    if( SignalType == 2 ) {
        translate( [MastWidth/4,0,0] ) rotate( [-35,0,0] ) blende_typ2( MastWidth/5, MastWidth/2.5, WallTickness/5, ShowLed );
    }
    if( SignalType == 3 ) {
        translate( [MastWidth/4,0,0] ) rotate( [-35,0,0] ) blende_typ3( MastWidth/5, MastWidth/2.5, WallTickness/5, ShowLed );
    }
    if( SignalType == 4 ) {
        translate( [MastWidth/4,0,0] ) rotate( [-35,0,0] ) blende_typ4( MastWidth/5, MastWidth/2.5, WallTickness/5, ShowLed );
    }
    if( SignalType == 5 ) {
        translate( [MastWidth/4,0,0] ) rotate( [-35,0,0] ) blende_typ5( MastWidth/5, MastWidth/2.5, WallTickness/5, ShowLed );
    }
    if( SignalType == 6 ) {
        translate( [MastWidth/4,0,0] ) rotate( [-35,0,0] ) blende_typ6( MastWidth/5, MastWidth/2.5, WallTickness/5, ShowLed );
    }
}

/**
 * @brief generate a mast type 1
 *
 * param x          x size of the mast
 * param y          y size of the mast
 * param z          z size of the mast
 * param wandung    Wall thickness
 **/
module mast_typ1( x, y, z, wandung, fuss ) {
    /* mast innen */
    x_1 = x - wandung * 2;
    y_1 = y - wandung * 2;
    z_1 = z - wandung * 2;
    dif = ( z / ( MastKnotSheet + 1  ) );
    dif_Crampons = ( z / ( MastCrampons + 1  ) );
    /* gen mast */
    union() {
        difference() {
            union() {
                /**
                 * mast core sturcture
                 **/
                cube( [x,y,z] );
                translate( [x/2,y/2,-wandung * 2] ) cube( [ x*4,x*4, wandung * 4], center = true );
                translate( [x/2,y/2,-MastFootLength] ) cylinder( h=MastFootLength, r=fuss, $fn=32 );                
                for( i = [1:1:MastKnotSheet ] ) {
                    translate( [ 0,y/8, ( i * dif  ) ] ) sphere( y/15, $fn=16 );
                    translate( [ 0,y/8*7, ( i * dif ) ] ) sphere( y/15, $fn=16 );
                    translate( [ x,y/8, ( i * dif ) ] ) sphere( y/15, $fn=16 );
                    translate( [ x,y/8*7, ( i * dif ) ]  ) sphere( y/15, $fn=16 );
                }
                /**
                 * plattform
                 **/
                difference() {
                    union() {
                        // floor plate
                        difference() {
                            steps_x = ( ( x*3 - wandung * 2 ) / wandung ) - ( ( x*3 - wandung * 2 ) / wandung ) % 2 + 1;
                            steps_y = ( ( y*3 - wandung * 2 ) / wandung ) - ( ( y*3 - wandung * 2 ) / wandung ) % 2 + 1;
                            steps_x_dif = ( x*3 - wandung * 2 ) / steps_x;
                            steps_y_dif = ( y*3 - wandung * 2 ) / steps_y;
                            echo( steps_x, steps_x_dif );
                            echo( steps_y, steps_y_dif );
                            translate( [-x,0,z] ) cube( [ x*3,y*3,wandung] );
                            for( ix = [0:2:steps_x - 1 ] ) {
                                for( iy = [0:2:steps_y - 1 ] ) {
                                    translate( [ ix * steps_x_dif - x + wandung, iy * steps_y_dif + wandung ,z] ) cube( [wandung,wandung,wandung] );
                                }                                    
                            }
                        }
                        translate( [-x,0,z-y/2] ) cube( [ x*3, wandung, y/2] );
                        translate( [-x,y-wandung,z-y/2] ) cube( [ x*3, wandung, y/2] );
                        translate( [0,y-0.1,z-y] ) rotate( [0,0, atan( x/ (y*2) ) ] ) cube( [ wandung, sqrt( (y*2)*(y*2) + x*x ), y] );
                        translate( [x-wandung,y,z-y] ) rotate( [0,0, -atan( x/ (y*2) ) ] ) cube( [ wandung, sqrt( (y*2)*(y*2) + x*x ), y] );
                        // railing
                        translate( [-x,y*0.5,z] ) cube( [wandung, wandung, x*4 ] );
                        translate( [-x,y*1.8,z] ) cube( [wandung, wandung, x*4 ] );
                        translate( [-x,y*3-wandung,z] ) cube( [wandung, wandung, x*4 ] );
                        translate( [2*x-wandung,y*0.5,z] ) cube( [wandung, wandung, x*4 ] );
                        translate( [2*x-wandung,y*1.8,z] ) cube( [wandung, wandung, x*4 ] );
                        translate( [2*x-wandung,y*3-wandung,z] ) cube( [wandung, wandung, x*4 ] );
                        translate( [2*x-wandung,0.5*y,z+x*4-wandung] ) cube( [wandung, 2.5*y-wandung, wandung ] );
                        translate( [-x,0.5*y,z+x*4-wandung] ) cube( [wandung, 2.5*y-wandung, wandung ] );
                        translate( [2*x-wandung,0.5*y,z+x*2-wandung] ) cube( [wandung, 2.5*y-wandung, wandung ] );
                        translate( [-x,0.5*y,z+x*2-wandung] ) cube( [wandung, 2.5*y-wandung, wandung ] );
                        translate( [-x,3*y-wandung,z+x*2-wandung] ) cube( [x*3, wandung, wandung ] );
                        translate( [-x,3*y-wandung,z+x*4-wandung] ) cube( [x*3, wandung, wandung ] );
                    }
                    // floor plate knot cutcout
                    translate( [0,y,z-y] ) rotate( [0,-atan( x/ (y) ),180 ] ) cube( [ x*2, y, y/2 ] );
                    translate( [x,0,z-y] ) rotate( [0,-atan( x/ (y) ),0 ] ) cube( [ x*2, y, y/2 ] );
                    translate( [-x,y,z-2*y] ) rotate( [ atan( (x/ (y+ wandung) ) ),0,0] ) cube( [x*3,y*3,y] );
                }
            }
            /**
             * mast core structure cutout
             **/
           translate( [(x-x_1)/2,(y-y_1)/2,-z/2] ) cube( [x_1,y_1,z*2] );
            for( i = [0:1:MastKnotSheet ] ) {
                translate( [ 0,y/4, ( i * dif ) + dif / 100 * ( 100 - MastKnotRatio ) - ( dif / 100 * ( 100 - MastKnotRatio ) ) / 2   ]  ) cube( [x,y/2, dif / 100 * MastKnotRatio] );
            }
           translate( [(x-x_1-wandung*2)/2-wandung/3,y/4,0] ) cube( [wandung / 2,y/2,z] );
           translate( [(x-x_1-wandung*2)/2+x-wandung/3,y/4,0] ) cube( [wandung / 2,y/2,z] );
        }
        /**
         * crampons
         **/
        for( i = [0:1:MastCrampons  - 1 ] ) {
            translate( [ x/2 - x/10 ,y, ( i * dif_Crampons ) + dif_Crampons / 2 ] ) cube( [ x/5 , y/2, x/5 ] );
            translate( [ x/2 - x/10 ,y + y/2 - x/10, ( i * dif_Crampons ) + dif_Crampons / 2 ] ) cube( [ x/5 , x/5, y/2 ] );
            translate( [ x/2 - x/10 ,y, ( i * dif_Crampons ) + dif_Crampons / 2 - x/5] ) rotate( [ atan( (x/5) / (y/2) ) ,0,0] ) cube( [ x/5 , y/2, x/5 ] );
        }
        /**
         * front sign
         **/
        translate( [0,-y/2,z/4] ) cube( [ x , y/10, z/2 ] );
        translate( [x/2-x/10,-y/2,z/4] ) cube( [ x/5 , y/2, z/12 ] );
        translate( [x/2-x/10,-y/2,z/4 + z/2 - z/12 ] ) cube( [ x/5 , y/2, z/12 ] );
    }
}

module blende_typ1( x, y, z, led ) {
    x_1 = ( x / 11 ) * 3;
    x_2 = ( x / 11 ) * 8;
    y_1 = ( y / 11 ) * 2;
    y_2 = ( y / 11 ) * 7;
    y_3 = ( y / 11 ) * 9;
    y_4 = ( y / 11 ) * 4.0;
    y_5 = ( y / 11 ) * 5.0;
    
    color("grey",1.0) union() {
        difference() {
            blende( x, y, z );

            translate( [x_1,-0.1,y_1] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_1,0.5,y_1] ) LED("green");

            translate( [x_2,-0.1,y_1] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_2,0.5,y_1] ) LED("red");
        }
        color("grey",1.0) translate( [x_1,-0,y_1] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_2,0,y_1] ) schirm( x/3, x / 6, x * 0.025, true );
    }
    /** show led */
    if( led ) {
        translate( [x_1,0.5,y_1] ) LED("red");
        translate( [x_2,0.5,y_1] ) LED("green");
    }
}

module blende_typ2( x, y, z, led ) {
    x_1 = ( x / 11 ) * 3;
    x_2 = ( x / 11 ) * 8;
    y_1 = ( y / 11 ) * 2;
    y_2 = ( y / 11 ) * 7;
    y_3 = ( y / 11 ) * 9;
    y_4 = ( y / 11 ) * 4.0;
    y_5 = ( y / 11 ) * 5.0;
    
    color("grey",1.0) union() {
        difference() {
            blende( x, y, z );

            translate( [x_1,-0.1,y_3] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_1,0.5,y_3] ) LED("green");

            translate( [x_2,-0.1,y_3] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_2,0.5,y_3] ) LED("red");
        }
        color("grey",1.0) translate( [x_1,-0,y_3] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_2,0,y_3] ) schirm( x/3, x / 6, x * 0.025, true );
    }
    /** show led */
    if( led ) {
        translate( [x_1,0.5,y_3] ) LED("red");
        translate( [x_2,0.5,y_3] ) LED("green");
    }
}

module blende_typ3( x, y, z, led ) {
    x_1 = ( x / 11 ) * 3;
    x_2 = ( x / 11 ) * 8;
    y_1 = ( y / 11 ) * 2;
    y_2 = ( y / 11 ) * 7;
    y_3 = ( y / 11 ) * 9;
    y_4 = ( y / 11 ) * 4.0;
    y_5 = ( y / 11 ) * 5.0;
    
    color("grey",1.0) union() {
        difference() {
            blende( x, y, z );

            translate( [x_2,-0.1,y_3] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_2,0.5,y_3] ) LED("green");

            translate( [x_1,-0.1,y_1] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_1,0.5,y_1] ) LED("red");

            translate( [x_2,-0.1,y_1] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_2,0.5,y_1] ) LED("yellow");
        }
        color("grey",1.0) translate( [x_2,0,y_3] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_1,0,y_1] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_2,0,y_1] ) schirm( x/3, x / 6, x * 0.025, true );
    }
    /** show led */
    if( led ) {
        translate( [x_2,0.5,y_3] ) LED("green");
        translate( [x_1,0.5,y_1] ) LED("red");
        translate( [x_2,0.5,y_1] ) LED("yellow");
    }
}

module blende_typ4( x, y, z, led ) {
    x_1 = ( x / 11 ) * 3;
    x_2 = ( x / 11 ) * 8;
    y_1 = ( y / 11 ) * 2;
    y_2 = ( y / 11 ) * 7;
    y_3 = ( y / 11 ) * 9;
    y_4 = ( y / 11 ) * 4.0;
    y_5 = ( y / 11 ) * 5.0;
    
    color("grey",1.0) union() {
        difference() {
            blende( x, y, z );

            translate( [x_1,-0.1,y_3] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_1,0.5,y_3] ) LED("red");

            translate( [x_2,-0.1,y_3] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_2,0.5,y_3] ) LED("green");

            translate( [x_1,-0.1,y_1] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_1,0.5,y_1] ) LED("red");

            translate( [x_2,-0.1,y_1] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_2,0.5,y_1] ) LED("yellow");
        }
        color("grey",1.0) translate( [x_1,-0,y_3] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_2,0,y_3] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_1,0,y_1] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_2,0,y_1] ) schirm( x/3, x / 6, x * 0.025, true );
    }
    /** show led */
    if( led ) {
        translate( [x_1,0.5,y_3] ) LED("red");
        translate( [x_2,0.5,y_3] ) LED("green");
        translate( [x_1,0.5,y_1] ) LED("red");
        translate( [x_2,0.5,y_1] ) LED("yellow");
    }
}

module blende_typ5( x, y, z, led ) {
    x_1 = ( x / 11 ) * 3;
    x_2 = ( x / 11 ) * 8;
    y_1 = ( y / 11 ) * 2;
    y_2 = ( y / 11 ) * 7;
    y_3 = ( y / 11 ) * 9;
    y_4 = ( y / 11 ) * 4.0;
    y_5 = ( y / 11 ) * 5.0;
    
    color("grey",1.0) union() {
        difference() {
            blende( x, y, z );
            
            translate( [x_1,-0.1,y_2] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_1,0.5,y_2] ) LED("red");

            translate( [x_2,-0.1,y_2] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_2,0.5,y_2] ) LED("red");

            translate( [x_1,-0.1,y_1] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_1,0.5,y_1] ) LED("green");

            translate( [x_1,-0.1,y_3] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_1,0.5,y_3] ) LED("yellow");
            
        }
        color("grey",1.0) translate( [x_1,-0,y_2] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_2,0,y_2] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_1,0,y_1] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_1,0,y_3] ) schirm( x/3, x / 6, x * 0.025, true );
    }
    /** show led */
    if( led ) {
        translate( [x_2,0.5,y_2] ) LED("red");
        translate( [x_1,0.5,y_2] ) LED("red");
        translate( [x_1,0.5,y_1] ) LED("yellow");
        translate( [x_1,0.5,y_3] ) LED("green");
    }
}

module blende_typ6( x, y, z, led ) {
    x_1 = ( x / 11 ) * 3;
    x_2 = ( x / 11 ) * 8;
    y_1 = ( y / 11 ) * 2;
    y_2 = ( y / 11 ) * 7;
    y_3 = ( y / 11 ) * 9;
    y_4 = ( y / 11 ) * 4.0;
    y_5 = ( y / 11 ) * 5.0;
    
    color("grey",1.0) union() {
        difference() {
            blende( x, y, z );
            
            translate( [x_1,-0.1,y_2] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_1,0.5,y_2] ) LED("red");

            translate( [x_2,-0.1,y_2] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_2,0.5,y_2] ) LED("red");

            translate( [x_1,-0.1,y_1] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_1,0.5,y_1] ) LED("green");

            translate( [x_1,-0.1,y_3] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_1,0.5,y_3] ) LED("yellow");

            translate( [x_1,-0.1,y_4] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_1,0.5,y_4] ) LED("white");            

            translate( [x_2,-0.1,y_5] ) rotate( [0,90,90] ) cylinder( h=1, r=x / 10, $fn=64 );
            translate( [x_2,0.5,y_5] ) LED("white");            
        }
        color("grey",1.0) translate( [x_1,-0,y_2] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_2,0,y_2] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_1,0,y_1] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_1,0,y_3] ) schirm( x/3, x / 6, x * 0.025, true );
        color("grey",1.0) translate( [x_1,0,y_4] ) schirm( x/4, x / 10, x * 0.025, true );
        color("grey",1.0) translate( [x_2,0,y_5] ) schirm( x/4, x / 10, x * 0.025, true );
    }
    /** show led */
    if( led ) {
        translate( [x_2,0.5,y_2] ) LED("red");
        translate( [x_1,0.5,y_2] ) LED("red");
        translate( [x_1,0.5,y_1] ) LED("yellow");
        translate( [x_1,0.5,y_3] ) LED("green");
        translate( [x_1,0.6,y_4] ) LED("white");
        translate( [x_2,0.6,y_5] ) LED("white");
    }
}

module blende( x, y, z ) {
    difference() {
        translate( [0,0,0] ) cube( [x,z*2,y ] );
        translate( [0,z/2,y] ) rotate( [0,45,0] ) cube( [ x/5, z*4, x/5 ], center = true );
        translate( [x,z/2,y] ) rotate( [0,45,0] ) cube( [ x/5 ,z*4 ,x/5 ], center = true );
        translate( [z/2,z/2.5 + 0.2,z/2] ) cube( [x-z, z*2 ,y-sqrt( ((x/8)*(x/8)) )-z ] );
    }
}

module blende_back( x, y, z, x_mast, y_mast, wandung ) {
    
    color("grey",1.0) union() {
        difference() {
            union() {
                translate( [0,0,0] ) cube( [x,z,y ] );
                translate( [x/3,0,0] ) cube( [x_mast+ wandung*2,y_mast + wandung,y/8 ] );
            }
            translate( [x/3+wandung,0,-wandung] ) cube( [x_mast,y_mast,y/8 ] );
            translate( [0,z/2,y] ) rotate( [0,45,0] ) cube( [ x/5, z*2, x/5 ], center = true );
            translate( [x,z/2,y] ) rotate( [0,45,0] ) cube( [ x/5 ,z*2 ,x/5 ], center = true );
        }
    }
}

module helper_blende( x ,y ,z, x_mast, y_mast, wandung ) {

    color("grey",1.0) union() {
        difference() {
            union() {
                translate( [-x/2+z/2,-y/3+z,z] ) cube( [ x*2,y/3,x*2.3 ] );
                translate( [-x/2+z/2,0,y*0.2] ) cube( [ x*2,z*10,wandung * 2 ] );
                translate( [-x/2+z/2,0,y*0.8] ) cube( [ x*2,z*10,wandung * 2 ] );
                translate( [+x/2+z/2,0,z] ) cube( [ wandung * 2,z*10,x*2.3] );
            }
            difference() {
                union() {
                    translate( [0,0,0] ) cube( [ x,z,y ] );
                    translate( [z,-y/3,z/2] ) cube( [x-z*2, y/3 ,y-sqrt( ((x/8)*(x/8)) )-z ] );
                    translate( [0,0,0] ) cube( [x, z*10 ,y ] );
                }
                // translate( [x/3+wandung,0,-wandung] ) cube( [x_mast,y_mast,y/8 ] );
                translate( [0,z/2,y] ) rotate( [0,45,0] ) cube( [ x/5, z*2, x/5 ], center = true );
                translate( [x,z/2,y] ) rotate( [0,45,0] ) cube( [ x/5 ,z*2 ,x/5 ], center = true );
            }
        }
    }

}

module schirm( high, radius, wandung, schrauben ) {
    union() {
        intersection() {
            difference() {
                rotate( [90,0,0] ) cylinder( h=high,r=radius, $fn=64 );
                rotate( [90,0,0] ) translate( [0,0,-0.1] ) cylinder( h=high + 0.1,r=radius - wandung, $fn=64 );
                rotate( [0,90,0] ) translate( [radius + wandung * 2,-high,0] ) scale( [radius * 2 / high,1,1] ) cylinder( h=radius * 2, r=high, $fn=64, center = true );
            }
            scale( [0.75,1,1] ) cylinder( h=radius * 2, r=high, $fn=64, center = true );
        }
        if( schrauben ) {
            difference() {
                cube( [ ( radius + wandung ) * 2, wandung, ( radius + wandung ) * 2 ], center = true );
                rotate( [90,0,0] ) translate( [0,0,-1] ) cylinder( h=high + 0.1,r=radius - wandung, $fn=64 );
            }
            rotate( [ 90,0,0 ] ) translate( [-radius + wandung/2,-radius + wandung/2,wandung] ) cylinder( h=wandung, r = wandung, $fn=6, center = true );
            rotate( [ 90,0,0 ] ) translate( [+radius - wandung/2,-radius + wandung/2,wandung] ) cylinder( h=wandung, r = wandung, $fn=6, center = true );
            rotate( [ 90,0,0 ] ) translate( [-radius + wandung/2,+radius - wandung/2,wandung] ) cylinder( h=wandung, r = wandung, $fn=6, center = true );
            rotate( [ 90,0,0 ] ) translate( [+radius - wandung/2,+radius - wandung/2,wandung] ) cylinder( h=wandung, r = wandung, $fn=6, center = true );
        }
    }
}

module LED( color ) {
    // LED type 1 = 0603
    if( LedType == 0 ) {
         rotate( [90,90,0] ) union() {
            cube( [1.8,1.1,0.4], center = true );
            color( color,1.0) cube( [1.4,1.1,0.55], center = true );
        }
    }
    // LED type 1 = 0805
    if( LedType == 1 ) {
         rotate( [90,90,0] ) union() {
            cube( [2.4,1.6,0.4], center = true );
            color( color,1.0) cube( [1.4,1.6,0.75], center = true );
        }
    }
    // LED type 2 = 1206
    if( LedType == 2 ) {
         rotate( [90,90,0] ) union() {
            cube( [3.5,1.9,0.4], center = true );
            color( color,1.0) cube( [2.2,1.9,0.75], center = true );
        }
    }
    // LED type 3 = 3528
    if( LedType == 3 ) {
         rotate( [90,90,0] ) union() {
            color( color,1.0) cube( [3.8,2.7,0.7], center = true );
            // cube( [2.2,1.9,0.75], center = true );
        }
    }
    // LED type 3 = 3528
    if( LedType == 4 ) {
         rotate( [90,90,0] ) union() {
            color( color,1.0) translate( [0,0,-0.3] ) cube( [5.7,5.3,1.2], center = true );
            // cube( [2.2,1.9,0.75], center = true );
        }
    }
}
