module pcie_tx (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [31:0] data_in,
    input wire [3:0] pkt_length, // Length of the packet in bytes
    output reg busy,
    output reg [31:0] data_out
);
    reg [3:0] count;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            busy <= 0;
            count <= 0;
            data_out <= 0;
        end else begin
            if (start && !busy) begin
                busy <= 1;
                count <= pkt_length; // Load the packet length
                data_out <= data_in; // Load the data to output
            end else if (busy) begin
                if (count > 0) begin
                    count <= count - 1; // Decrement the count
                    // For simplicity, we keep data_out the same
                end else begin
                    busy <= 0; // Packet transmission complete
                end
            end
        end
    end
endmodule