module top_module(
    input [7:0] D,
    input FSM_selector_D,
    input AR,
    input CLK,
    output reg [30:0] Q_reg,  // Changed to output reg
    output reg Data_A         // Changed to output reg
);always @(posedge CLK) begin
    if (AR) begin
        Q_reg <= 0;
    end else begin
        case (FSM_selector_D)
            1'b0: Q_reg <= Q_reg;
            1'b1: Q_reg <= Q_reg + D;
        endcase
    end
end

always @* begin
    Data_A = (Q_reg[7:0] + D[7:0]) > 8'hFF ? 1'b1 : 1'b0;  // Added an always block for combinational logic
end

endmodule