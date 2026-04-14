module data_forwarding_unit(
    input [31:0] rs1,
    input [31:0] rs2,
    input [1:0] forward_sel,
    output reg [31:0] forwarded_data
);
    always @(*) begin
        case (forward_sel)
            2'b00: forwarded_data = rs1;
            2'b01: forwarded_data = rs2;
            2'b10: forwarded_data = rs1; // latest value from rs1
            2'b11: forwarded_data = rs2; // latest value from rs2
            default: forwarded_data = 32'b0; // default case
        endcase
    end
endmodule