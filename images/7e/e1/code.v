module top_module(
    input CLK, // clock signal
    input EN, // enable signal
    input TE, // test enable signal
    output reg ENCLK // gated clock signal
);always @(posedge CLK) begin
    if (EN && TE) begin
        ENCLK <= 1'b1;
    end else begin
        ENCLK <= 1'b0;
    end
end

endmodule