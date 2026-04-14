module ShiftReg_16_load(
   input                clk,
   input                rst,
   input                load,
   input  [15:0]        load_val,
   output reg [15:0]    Q
);
    always@(posedge clk)begin
        if(rst) Q <= 16'd0;
        else if(load) Q <= load_val;
        else Q <= {Q[14:0], 1'b0};
    end
endmodule