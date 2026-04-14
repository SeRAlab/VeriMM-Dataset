module top_module(input wire clk,         
                 input wire [7:0] pos,   
                 output reg servo);localparam M = 93; 
localparam N = $clog2(M);

reg [N-1:0] divcounter = 0;
reg tic = 0;


always @(posedge clk)
 tic <= (divcounter == M - 2);


always @(posedge clk)
 if (tic)
   divcounter <= 0;
 else
   divcounter <= divcounter + 1;


reg [10:0] angle_counter = 0;

wire [8:0] pose = {1'b0, pos} + 9'd46;

always @(posedge clk)
 if (tic)
   angle_counter <= angle_counter + 1;

always @(posedge clk)
 servo <= (angle_counter < {3'b00, pose});


endmodule