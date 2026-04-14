module nat (
    input clk,
    input reset,
    input [31:0] ipv4_in,
    input [15:0] port_in,
    output reg [31:0] ipv4_out,
    output reg [15:0] port_out,
    output reg valid
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ipv4_out <= 32'b0;
            port_out <= 16'b0;
            valid <= 1'b0;
        end else begin
            ipv4_out <= {8'd192, ipv4_in[23:0]};
            port_out <= port_in + 16'd1000;
            valid <= 1'b1;
        end
    end
endmodule