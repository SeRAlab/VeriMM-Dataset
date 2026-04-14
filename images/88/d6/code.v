module parallel_to_serial(
   input                clk ,
   input                rst_n,
   input                load,
   input [15:0]         parallel_data,
 
   output reg           serial_out
);
    reg [15:0] shift_reg;
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) begin
            shift_reg <= 16'd0;
            serial_out <= 1'b0;
        end
        else if(load) begin
            shift_reg <= parallel_data;
        end
        else begin
            serial_out <= shift_reg[0];
            shift_reg <= shift_reg >> 1;
        end
    end
endmodule