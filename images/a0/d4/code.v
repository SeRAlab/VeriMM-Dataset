module top_module(CLK, EN, TE, ENCLK);input CLK, EN, TE;
output reg ENCLK;  // Change output to reg type

always @ (posedge CLK) begin
    if (EN) begin
        ENCLK <= 1'b1;  // Enable the clock when EN is high
    end else begin
        ENCLK <= 1'b0;  // Disable the clock when EN is low
    end
end

always @ (*) begin
    if (TE) begin
        ENCLK = CLK;  // If TE is high, pass CLK to ENCLK
    end
end

endmodule