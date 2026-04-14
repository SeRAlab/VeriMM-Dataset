module top_module(
    input clk,
    input rst,
    input wr0,
    input [LOG2_INTERMEDIATOR_DEPTH - 1:0] row0,
    input [65:0] v0,
    input wr1,
    input [LOG2_INTERMEDIATOR_DEPTH - 1:0] row1,
    input [65:0] v1,
    output wire push_to_adder,
    output wire [LOG2_INTERMEDIATOR_DEPTH - 1:0] row_to_adder,
    output wire [65:0] v0_to_adder,
    output wire [65:0] v1_to_adder,
    output wire push_to_y,
    output wire [65:0] v_to_y,
    output reg eof
);parameter INTERMEDIATOR_DEPTH = 1024;
parameter LOG2_INTERMEDIATOR_DEPTH = 10; // Updated to the correct value for log2(1024)

reg [65:0] memory [0:INTERMEDIATOR_DEPTH-1];

reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] read_address0;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] read_address1;

assign push_to_adder = (wr0 || wr1) && (read_address0 != read_address1);
assign row_to_adder = push_to_adder ? ((read_address0 < read_address1) ? read_address0 : read_address1) : 0;
assign v0_to_adder = push_to_adder ? memory[row_to_adder][65:0] : 0;
assign v1_to_adder = push_to_adder ? memory[row_to_adder][65:0] : 0;

assign push_to_y = wr0 || wr1;
assign v_to_y = memory[read_address0][65:0];

always @(posedge clk) begin
    if (rst) begin
        read_address0 <= 0;
        read_address1 <= 0;
        eof <= 0;
    end else begin
        if (wr0) begin
            memory[row0][65:0] <= v0;
        end
        if (wr1) begin
            memory[row1][65:0] <= v1;
        end
        if (push_to_adder) begin
            memory[row_to_adder][65:0] <= v0_to_adder + v1_to_adder;
        end
        if (push_to_y) begin
            read_address0 <= read_address0 + 1;
            if (read_address0 == read_address1) begin
                eof <= 1;
            end
        end
    end
end

endmodule