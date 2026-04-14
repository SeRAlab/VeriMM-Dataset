module dram_cell (
    input wire [3:0] data_in,
    input wire word_line,
    output reg [3:0] data_out
);
    reg [3:0] stored_data;

    always @(posedge word_line) begin
        stored_data <= data_in; // Write data when word line is high
    end

    always @(negedge word_line) begin
        data_out <= stored_data; // Output stored data when word line is low
    end
endmodule