module nat_device (
    input clk,
    input rst,
    input ctrl, // 1 for add, 0 for remove
    input [31:0] internal_ip,
    input [31:0] external_ip,
    output reg status // 1 for active, 0 for inactive
);
    reg [31:0] internal_ip_reg;
    reg [31:0] external_ip_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            internal_ip_reg <= 32'b0;
            external_ip_reg <= 32'b0;
            status <= 1'b0;
        end else begin
            if (ctrl) begin
                internal_ip_reg <= internal_ip;
                external_ip_reg <= external_ip;
                status <= 1'b1; // Mapping added
            end else if (internal_ip_reg == internal_ip) begin
                internal_ip_reg <= 32'b0;
                external_ip_reg <= 32'b0;
                status <= 1'b0; // Mapping removed
            end
        end
    end
endmodule