module clock_gate(input CLK, input EN, input TE, output reg ENCLK);

always @(posedge CLK) begin
    if (EN == 1'b1) begin
        ENCLK <= 1'b0;
    end else begin
        ENCLK <= CLK;
    end
end

endmodule