module top_module(
    input [3:0] parallel_in,
    input clk,
    input shift_enable,
    input reset,
    output serial_out
);reg [3:0] shift_reg;
    reg serial_out_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
            serial_out_reg <= 1'b0;
        end else if (shift_enable) begin
            shift_reg <= {shift_reg[2:0], parallel_in[0]};
            serial_out_reg <= shift_reg[3];
        end else begin
            shift_reg <= shift_reg;
            serial_out_reg <= shift_reg[3];
        end
    end
    
    assign serial_out = serial_out_reg;
    
endmodule