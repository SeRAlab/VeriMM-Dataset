module Counter_8_load(
   input                clk,
   input                rst,
   input                load,
   input  [7:0]         load_val,
   output reg [7:0]     Q  
);
    always@(posedge clk)begin
        if(rst) Q <= 8'd0;
        else if(load) Q <= load_val;
        else Q <= Q + 1;
    end
endmodule