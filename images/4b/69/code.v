module top_module(
    input wire clk,
    input wire reset,
    input wire [31:0] in_signal,
    output reg [15:0] out_signal
);reg [31:0] shift_reg [0:7];
reg [15:0] max_val;

integer i;

always @ (posedge clk) begin
    if (reset) begin
        for (i = 0; i < 8; i = i + 1) begin
            shift_reg[i] <= 0;
        end
        max_val <= 0;
    end else begin
        for (i = 7; i > 0; i = i - 1) begin
            shift_reg[i] <= shift_reg[i-1];
        end
        shift_reg[0] <= in_signal;
        
        max_val <= shift_reg[0][15:0];
        for (i = 1; i < 8; i = i + 1) begin
            if (shift_reg[i][15:0] > max_val) begin
                max_val <= shift_reg[i][15:0];
            end
        end
    end
end

assign out_signal = max_val;

endmodule