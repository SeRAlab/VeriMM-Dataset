module pcie_endpoint_controller (
    input clk,
    input reset,
    input req,         // request signal
    input [31:0] addr, // address for read/write
    input [31:0] data_in, // data to write (for write requests)
    output reg [31:0] data_out, // data output (for read requests)
    output reg ack    // acknowledge signal
);
    reg [31:0] memory [0:255]; // simple memory for storage

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack <= 0;
            data_out <= 32'b0;
        end else begin
            if (req) begin
                ack <= 1;
                // Handle read and write requests
                if (addr[31] == 1'b0) begin
                    // Write request
                    memory[addr[7:0]] <= data_in; // writing to memory
                end else begin
                    // Read request
                    data_out <= memory[addr[7:0]]; // reading from memory
                end
            end else begin
                ack <= 0; // clear ack if no request
            end
        end
    end
endmodule