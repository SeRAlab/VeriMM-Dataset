module top_module(
    input C,
    input S,
    input R,
    input T,
    output reg Q
);wire xorout;

    // XOR gate
    assign xorout = (C == 1'b1) ? T : Q;

    // D flip-flop with set and reset
    always @(posedge C) begin
        if (S == 1'b1 && R == 1'b0) begin
            Q <= 1'b1;
        end else if (S == 1'b0 && R == 1'b1) begin
            Q <= 1'b0;
        end else begin
            Q <= xorout;
        end
    end

endmodule