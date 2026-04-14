module PISO (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [7:0] parallel_data,
    output reg serial_out
);
    reg [7:0] shift_reg;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 8'b0;
            serial_out <= 1'b0;
        end else if (load) begin
            shift_reg <= parallel_data;
        end else begin
            serial_out <= shift_reg[7];
            shift_reg <= {shift_reg[6:0], 1'b0};
        end
    end
endmodule