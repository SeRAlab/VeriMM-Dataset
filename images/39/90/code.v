module nat(
    input wire clk,
    input wire rst,
    input wire [31:0] internal_ip,
    input wire [31:0] external_ip,
    output reg [31:0] translated_ip
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            translated_ip <= 32'b0;
        end else begin
            if (external_ip[31] == 1'b0) begin
                translated_ip <= internal_ip;
            end else begin
                translated_ip <= external_ip;
            end
        end
    end
endmodule