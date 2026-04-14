module top_module(
    input wire C,
    input wire R,
    input wire D,
    output reg Q
);always @(posedge C, posedge R) begin
        if (R) begin
            Q <= 0;
        end else begin
            Q <= D;
        end
    end

endmodule