module top_module(
    input wire D,
    input wire SET_B,
    input wire RESET_B,
    input wire CLK,
    output reg Q,
    output reg Q_B
    );always @(posedge CLK) begin
        if (!RESET_B) begin
            Q <= 1'b0;
            Q_B <= 1'b1;
        end else if (!SET_B) begin
            Q <= 1'b1;
            Q_B <= 1'b0;
        end else begin
            Q <= D;
            Q_B <= ~D;
        end
    end
    
endmodule