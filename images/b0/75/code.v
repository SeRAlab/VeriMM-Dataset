module shift_reg(
   input                clk ,
   input                rst_n,
   input                data_in,
 
   output reg [15:0]    Q  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 'd0;
        else Q <= {Q[14:0], data_in};
    end
endmodule