module top_module(
    input CLK,
    input RST,
    input UD,
    input [3:0] LOAD,
    output reg [3:0] Q
);always @(posedge CLK) begin
    if (RST) begin
        Q <= 4'b0;
    end else if (UD) begin
        Q <= Q + 1;
    end else begin
        Q <= Q - 1;
    end
end

always @(posedge CLK) begin
    if (LOAD) begin
        Q <= LOAD;
    end
end

endmodule