module data_buffer (
    input [7:0] A,
    output reg [15:0] Z,
    input TE_B,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);

always @(*) begin
    if (TE_B) begin
        Z = {A, 8'b0};
    end else begin
        Z = 16'b0;
    end
end

endmodule