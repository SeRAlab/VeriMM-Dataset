module NAT (
    input wire clk,
    input wire reset,
    input wire [31:0] private_ip,
    input wire [31:0] public_ip,
    input wire update,
    output reg [31:0] current_private_ip,
    output reg [31:0] current_public_ip
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_private_ip <= 32'b0;
            current_public_ip <= 32'b0;
        end else if (update) begin
            current_private_ip <= private_ip;
            current_public_ip <= public_ip;
        end
    end
endmodule