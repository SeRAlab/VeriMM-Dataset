module shift_register(
   input                clk ,
   input                rst_n,
   input                load,
   input [15:0]         load_value,
 
   output reg [15:0]    Q
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 16'd0;
        else if(load) Q <= load_value;
        else Q <= Q << 1;
    end
endmodule