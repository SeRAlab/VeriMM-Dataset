module RLE (
    input wire [7:0] data_in,  // 8-bit input data
    output reg [15:0] rle_out,  // 16-bit output for RLE result
    output reg valid           // Output valid signal
);
    integer i;
    reg [3:0] count;  // To count consecutive bits
    reg current_bit;   // To hold the current bit being processed

    always @(*) begin
        rle_out = 16'b0; // Reset output
        count = 0;
        valid = 0;
        current_bit = data_in[0];
        
        for (i = 0; i < 8; i = i + 1) begin
            if (data_in[i] == current_bit) begin
                count = count + 1;
            end else begin
                rle_out = {current_bit, count}; // Store the current bit and count
                valid = 1; // Set valid to indicate output is ready
                current_bit = data_in[i];
                count = 1; // Reset count for new bit
            end
        end
        
        // Handle the last bit sequence
        rle_out = {current_bit, count};
        valid = 1;
    end
endmodule