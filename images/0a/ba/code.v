module NAT(
    input clk,
    input reset,
    input [31:0] internal_ip,
    input [31:0] external_ip,
    input [15:0] internal_port,
    input [15:0] external_port,
    output reg [31:0] mapped_external_ip,
    output reg [15:0] mapped_external_port
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mapped_external_ip <= 32'b0;
            mapped_external_port <= 16'b0;
        end else begin
            mapped_external_ip <= external_ip; // map external IP
            mapped_external_port <= external_port; // map external port
        end
    end
endmodule