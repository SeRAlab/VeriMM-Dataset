module Barrel_shifter_256(
   input  [255:0]      data_in,
   input  [7:0]        shift_amt,
   input               dir,
   output reg [255:0]  data_out
);
    always@(*)begin
        if(dir) data_out = data_in << shift_amt;
        else data_out = data_in >> shift_amt;
    end
endmodule