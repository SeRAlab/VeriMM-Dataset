module pcie_packet_checker (
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    input wire [3:0] ctrl_in,
    output reg valid_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            valid_out <= 0;
        end else begin
            case (ctrl_in)
                4'b0000: // Data Packet
                    valid_out <= (data_in != 32'b0);
                4'b0001: // Acknowledgment Packet
                    valid_out <= (data_in != 32'b0);
                4'b0010: // Error Packet
                    valid_out <= 0;
                default: // Reserved
                    valid_out <= 0;
            endcase
        end
    end
endmodule