module RLE (
    input [7:0] data_in, // Input data stream (8 bits)
    input valid,         // Input valid signal
    output reg [15:0] rle_out, // Run-length encoded output (value + count)
    output reg rle_valid // Output valid signal
);
    reg [7:0] current_value;
    reg [3:0] count;

    always @(posedge valid) begin
        if (data_in != current_value) begin
            rle_out <= {current_value, count}; // Output current value and count
            rle_valid <= 1'b1; // Set output valid
            current_value <= data_in; // Update current value
            count <= 1; // Reset count
        end else begin
            count <= count + 1; // Increment count
            rle_valid <= 1'b0; // Clear output valid
        end
    end

    initial begin
        current_value = 8'b0;
        count = 4'b0;
        rle_out = 16'b0;
        rle_valid = 1'b0;
    end
endmodule