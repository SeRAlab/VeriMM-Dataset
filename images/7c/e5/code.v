module PISO_shift_reg(
   input                clk ,
   input                rst_n,
   input                load,
   input  [31:0]        data_in,
 
   output reg           data_out  
);
    reg [31:0] shift_reg;
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) 
            shift_reg <= 32'd0;
        else if(load) 
            shift_reg <= data_in;
        else 
            shift_reg <= {shift_reg[30:0], 1'b0};
    end
    
    always@(posedge clk) begin
        data_out <= shift_reg[31];
    end
endmodule