module top_module(
    input clk,
    input reset,
    input [31:0] in,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] out
);// Transition detector
    reg [1:0] det;
    always @(posedge clk) begin
        det <= {det[0], in[0] ^ det[1]};
    end

    // Shift register
    reg [3:0] q;
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0;
        end else if (load) begin
            q <= data;
        end else if (ena) begin
            q <= {q[2:0], det[1]};
        end
    end

    assign out = q;

endmodule