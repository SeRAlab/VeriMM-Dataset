module rle_encoder (
    input clk,
    input rst,
    input data_in,
    output reg [8:0] rle_out,
    output reg valid
);
    reg [3:0] count;
    reg last_bit;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            last_bit <= 0;
            rle_out <= 0;
            valid <= 0;
        end else begin
            if (data_in == last_bit) begin
                if (count < 8) begin
                    count <= count + 1;
                end
            end else begin
                if (count > 0) begin
                    rle_out <= {count, last_bit}; // Concatenate count and last_bit
                    valid <= 1;
                end
                last_bit <= data_in;
                count <= 1; // Reset count for new bit
            end
        end
    end
endmodule