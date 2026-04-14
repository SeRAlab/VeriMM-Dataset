module rle_encoder (
    input [7:0] data_in,
    input valid,
    output reg [15:0] rle_out,  // 8 bits count + 8 bits value
    output reg done
);
    integer i;
    reg [7:0] count;
    reg current_bit;
    
    always @(*) begin
        count = 0;
        rle_out = 0;
        done = 0;
        if (valid) begin
            current_bit = data_in[0];
            for (i = 0; i < 8; i = i + 1) begin
                if (data_in[i] == current_bit) begin
                    count = count + 1;
                end else begin
                    rle_out = {count, current_bit};
                    current_bit = data_in[i];
                    count = 1;
                end
            end
            rle_out = {count, current_bit};
            done = 1;
        end
    end
endmodule