module nat_device (
    input wire clk,
    input wire reset,
    input wire control,
    input wire [31:0] internal_ip,
    input wire [31:0] external_ip,
    output reg [31:0] output_ip
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_ip <= 32'b0;
        end else begin
            if (control) begin
                output_ip <= external_ip;
            end else begin
                output_ip <= internal_ip;
            end
        end
    end
endmodule