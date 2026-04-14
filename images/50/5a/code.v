module top_module(
    input clk,
    input rst,
    input load,
    input shift,
    input [7:0] din,
    output [7:0] parallel_out,
    output serial_out
);reg [7:0] shift_reg;
    reg [7:0] parallel_out_reg;
    reg serial_out_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 8'b0;
            parallel_out_reg <= 8'b0;
            serial_out_reg <= 1'b0;
        end
        else begin
            if (load) begin
                shift_reg <= din;
                parallel_out_reg <= din;
            end
            else if (shift) begin
                shift_reg <= {shift_reg[6:0], 1'b0};
                parallel_out_reg <= shift_reg;
                serial_out_reg <= shift_reg[7];
            end
            else begin
                parallel_out_reg <= shift_reg;
                serial_out_reg <= shift_reg[7];
            end
        end
    end
    
    assign parallel_out = parallel_out_reg;
    assign serial_out = serial_out_reg;
    
endmodule