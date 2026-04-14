module top_module(
    input [3:0] A,
    input LOAD,
    input CLK,
    output reg [3:0] Q
);always @(posedge CLK) begin
        if (LOAD) begin
            Q <= A;
        end else begin
            Q <= {Q[2:0], Q[3]};
        end
    end

endmodule