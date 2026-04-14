module Counter_8_load(
   input                clk,
   input                rst_n,
   input                load,
   input  [7:0]         load_val,
   output reg [7:0]     Q  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 8'd0;
        else if(load) Q <= load_val;
        else Q <= Q + 1;
    end
endmodule