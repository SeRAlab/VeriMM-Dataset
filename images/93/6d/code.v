module top_module(
    input SI,
    input CLK,
    output reg [3:0] Q
);always @(posedge CLK) begin
        Q <= {Q[2:0], SI};
    end

endmodule