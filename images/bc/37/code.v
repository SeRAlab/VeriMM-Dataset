module top_module(
    input A,
    input SLEEP_B,
    input CLK,
    output reg Y
);always @(posedge CLK) begin
        if (SLEEP_B == 0 && A == 1) begin
            Y <= 1;
        end else begin
            Y <= 0;
        end
    end

endmodule