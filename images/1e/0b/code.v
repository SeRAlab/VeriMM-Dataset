module NAT (
    input wire clk,
    input wire reset,
    input wire control,
    input wire [31:0] internal_ip,
    input wire [31:0] external_ip,
    output reg [31:0] translated_ip
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        translated_ip <= internal_ip;
    end else begin
        if (control) begin
            translated_ip <= external_ip;
        end else begin
            translated_ip <= internal_ip;
        end
    end
end

endmodule