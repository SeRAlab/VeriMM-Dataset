module top_module(
    input clk,
    input reset,      // Asynchronous active-high reset
    input load,       // Active-high parallel load input
    input [3:0] load_value, // 4-bit load value
    output [3:0] q,
    output carry);reg [3:0] q_next;
    reg [3:0] q_reg;
    reg carry_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_reg <= 4'b0000;
            carry_reg <= 1'b0;
        end
        else if (load) begin
            q_reg <= load_value;
            carry_reg <= (load_value == 4'b1010);
        end
        else begin
            q_reg <= q_next;
            carry_reg <= (q_next == 4'b1010);
        end
    end

    always @* begin
        q_next = q_reg + 1;
    end

    assign q = q_reg;
    assign carry = carry_reg;

endmodule