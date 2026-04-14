module nat (
    input wire clk,
    input wire rst,
    input wire [31:0] internal_ip,
    input wire [31:0] external_ip,
    input wire set_internal,
    input wire set_external,
    input wire translate,
    output reg [31:0] translated_ip
);

    reg [31:0] current_internal_ip;
    reg [31:0] current_external_ip;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_internal_ip <= 32'b0;
            current_external_ip <= 32'b0;
            translated_ip <= 32'b0;
        end else begin
            if (set_internal) begin
                current_internal_ip <= internal_ip;
            end
            if (set_external) begin
                current_external_ip <= external_ip;
            end
            if (translate) begin
                if (current_internal_ip == internal_ip) begin
                    translated_ip <= current_external_ip;
                end else begin
                    translated_ip <= 32'b0; // no translation found
                end
            end
        end
    end
endmodule