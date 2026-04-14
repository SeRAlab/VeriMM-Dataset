module ethernet_mac_controller (
    input clk,
    input rst,
    input [63:0] data_in,
    input valid,
    output reg [31:0] fcs_out,
    output reg frame_valid
);
    reg [31:0] computed_fcs;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            computed_fcs <= 32'b0;
            fcs_out <= 32'b0;
            frame_valid <= 1'b0;
        end else if (valid) begin
            // Simple FCS computation via XOR
            computed_fcs <= computed_fcs ^ data_in[31:0] ^ data_in[63:32];
            fcs_out <= computed_fcs;
            frame_valid <= (computed_fcs == fcs_out);
        end
    end
endmodule