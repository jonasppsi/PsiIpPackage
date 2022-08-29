
`timescale 1ps/1ps

module test # (
   parameter CLKIN_FREQ   = 80000000
)
(
   input        refclk,                     // lvds reference clock
   input        reset,                      // reset (active high)

   output       clkout0,                  // lvds channel 0 clock output P-side
   output [3:0] dataout0

) ;

assign clkout0=1;
assign dataout0=10;


endmodule
