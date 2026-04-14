module crystal_oscillator (
    input wire clk,
    input wire reset,
    output reg osc_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            osc_out <= 0;
        end else begin
            osc_out <= ~osc_out;
        end
    end
endmodule