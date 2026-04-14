module branch_predictor (
    input wire branch_outcome,
    input wire clk,
    output reg [1:0] state
);
    initial begin
        state = 2'b00; // Initial state is 00
    end

    always @(posedge clk) begin
        case (state)
            2'b00: state <= branch_outcome ? 2'b01 : 2'b00; // 00 -> 01 or stays
            2'b01: state <= branch_outcome ? 2'b10 : 2'b00; // 01 -> 10 or goes back to 00
            2'b10: state <= branch_outcome ? 2'b11 : 2'b01; // 10 -> 11 or goes back to 01
            2'b11: state <= branch_outcome ? 2'b11 : 2'b10; // 11 -> stays or goes back to 10
            default: state <= 2'b00; // Default case
        endcase
    end
endmodule