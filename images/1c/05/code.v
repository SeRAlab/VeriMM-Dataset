module dram_cell (
    input wire data_in,      // Data input
    input wire word_line,    // Write control
    input wire sense_line,    // Read control
    output reg data_out      // Data output
);
    reg stored_data;         // Register to store the data

    always @(posedge word_line) begin
        stored_data <= data_in; // Write operation
    end

    always @(posedge sense_line) begin
        data_out <= stored_data; // Read operation
    end
endmodule