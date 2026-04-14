module crystal_oscillator (
    input clk,
    input control,
    output reg out
);
    always @(posedge clk) begin
        if (control) begin
            out <= ~out; // Toggle output on each clock edge when control is high
        end else begin
            out <= 0; // Hold output low when control is low
        end
    end
endmodule