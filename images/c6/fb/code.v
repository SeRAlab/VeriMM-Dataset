module Register(input [31:0] IN, input Clk, Reset, Load, output reg [31:0] OUT);

    always @(posedge Clk) begin
        if (Reset) begin
            OUT <= 0;
        end else if (Load) begin
            OUT <= IN;
        end
    end

endmodule