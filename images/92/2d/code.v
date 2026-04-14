module top_module(
    input  wire IN,
    input  wire CLK,
    output reg  OUT
);reg last_IN;

    always @(posedge CLK) begin
        if (IN && !last_IN) begin
            OUT <= 1'b1;
        end else begin
            OUT <= 1'b0;
        end
        last_IN <= IN;
    end

endmodule