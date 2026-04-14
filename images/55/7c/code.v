module verified_PISO_shift_reg(
   input                clk ,
   input                rst_n,
   input                load,
   input  [7:0]         parallel_in,
 
   output reg           serial_out 
);
    reg [7:0] shift_reg;

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) shift_reg <= 8'd0;
        else if(load) shift_reg <= parallel_in;
        else shift_reg <= {shift_reg[6:0], 1'b0};
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) serial_out <= 1'b0;
        else serial_out <= shift_reg[7];
    end
endmodule