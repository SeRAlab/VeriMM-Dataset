module top_module(
    input clk,
    input reset,  // sync active-high reset
    input load,
    input ena,
    input [3:0] data_in,
    output [3:0] data_out);reg [3:0] shift_reg;
    wire [1:0] select;
    wire [3:0] shifted_data;

    // 2-to-4 decoder
    assign select[0] = ~shift_reg[3] & ~shift_reg[2];
    assign select[1] = ~shift_reg[3] & shift_reg[2];

    // 4-bit shift register
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else if (load) begin
            shift_reg <= data_in;
        end else if (ena) begin
            shift_reg <= {shift_reg[2:0], shift_reg[3]};
        end
    end

    // 2-to-1 multiplexer
    assign shifted_data = {shift_reg[1:0], 2'b0};
    assign data_out = load ? data_in : (select[1] ? shifted_data : shift_reg);

endmodule