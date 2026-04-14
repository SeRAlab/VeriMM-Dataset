module pcie_interface (
    input clk,
    input rst,
    input [1:0] req_type, // 00: Read, 01: Write
    input [31:0] addr,
    input [31:0] data_in,
    output reg [31:0] data_out,
    output reg success
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 0;
            success <= 0;
        end else begin
            case(req_type)
                2'b00: begin // Read
                    // Simulate reading by just outputting the address as data_out
                    data_out <= addr; 
                    success <= 1; // Assume read is always successful
                end
                2'b01: begin // Write
                    // Simulate writing by ignoring the data
                    success <= 1; // Assume write is always successful
                end
                default: begin
                    success <= 0;
                end
            endcase
        end
    end
endmodule