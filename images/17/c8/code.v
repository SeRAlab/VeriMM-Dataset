module RLE(
    input [7:0] data_in,
    output reg [7:0] value_out,
    output reg [3:0] count_out
);
    integer i;
    reg [7:0] current_value;
    reg [3:0] current_count;

    always @(*) begin
        current_value = data_in[7]; // Start with the most significant bit
        current_count = 1;
        value_out = 0;
        count_out = 0;
        
        for (i = 6; i >= 0; i = i - 1) begin
            if (data_in[i] == current_value) begin
                current_count = current_count + 1;
            end else begin
                value_out = {value_out, current_value}; // Concatenate the current value
                count_out = {count_out, current_count}; // Concatenate the count
                current_value = data_in[i]; // Update to new value
                current_count = 1; // Reset count
            end
        end
        
        // Add the last run-length pair
        value_out = {value_out, current_value};
        count_out = {count_out, current_count};
    end
endmodule