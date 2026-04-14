module pcie_packet_receiver(
    input clk,
    input rst_n,
    input [31:0] data_in,
    input [7:0] addr_in,
    input write_en,
    input read_en,
    output reg [31:0] data_out,
    output reg [7:0] addr_out
);
    reg [31:0] packet_memory [0:4]; // Memory for 5 packets
    reg [2:0] write_pointer;
    reg [2:0] read_pointer;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_pointer <= 3'b000;
            read_pointer <= 3'b000;
            data_out <= 32'b0;
            addr_out <= 8'b0;
        end else begin
            if (write_en && write_pointer < 5) begin
                packet_memory[write_pointer] <= data_in;
                write_pointer <= write_pointer + 1;
            end
            if (read_en && read_pointer < write_pointer) begin
                data_out <= packet_memory[read_pointer];
                addr_out <= addr_in; // Output the address for the packet
                read_pointer <= read_pointer + 1;
            end
        end
    end
endmodule