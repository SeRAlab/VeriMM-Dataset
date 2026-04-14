module pcie_receiver (
    input wire clk,
    input wire rst,
    input wire [31:0] data_in,
    output reg valid_out
);
    reg [31:0] data_buffer [0:3]; // Store 4 data values
    reg [1:0] write_ptr; // Pointer to write data
    reg [1:0] read_ptr; // Pointer to read data

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            write_ptr <= 0;
            read_ptr <= 0;
            valid_out <= 0;
        end else begin
            // Write data into buffer
            data_buffer[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;

            // Generate valid signal when data is present
            if (write_ptr >= read_ptr + 1) begin
                valid_out <= 1;
                read_ptr <= read_ptr + 1; // Move read pointer
            end else begin
                valid_out <= 0;
            end
        end
    end
endmodule