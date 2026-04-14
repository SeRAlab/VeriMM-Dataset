module load_reg(
   input                clk ,
   input                rst_n,
   input                load,
   input  [31:0]        data_in,
 
   output reg [31:0]    Q  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 'd0;
        else if(load) Q <= data_in;
    end
endmodule