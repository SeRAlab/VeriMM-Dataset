module rle_encoder (
    input [7:0] data_in,
    output reg [15:0] run_length,
    output reg [7:0] bit_value,
    output reg valid
);

    integer i;
    reg [7:0] count;
    
    always @(*) begin
        count = 0;
        run_length = 0;
        bit_value = 0;
        valid = 0;
        
        for (i = 0; i < 8; i = i + 1) begin
            if (i == 0 || data_in[i] == data_in[i-1]) begin
                count = count + 1;  // Increment count for the same bits
            end else begin
                // Output the previous run
                run_length = {count, run_length[7:0]};
                bit_value = {data_in[i-1], bit_value[7:0]};
                count = 1;  // Reset count for the new bit
            end
        end
        // Output the final run
        run_length = {count, run_length[7:0]};
        bit_value = {data_in[7], bit_value[7:0]};
        valid = 1;
    end
endmodule