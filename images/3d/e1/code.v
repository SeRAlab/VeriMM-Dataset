module rle_encoder (
    input clk,
    input rst,
    input data_in,
    output reg [3:0] length,
    output reg bit_out,
    output reg valid
);
    reg [3:0] count;
    reg state; // 0 for counting '0's, 1 for counting '1's

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            length <= 0;
            bit_out <= 0;
            valid <= 0;
            state <= 0;
        end else begin
            if (count < 15) begin
                if ((state == 0 && data_in == 0) || (state == 1 && data_in == 1)) begin
                    count <= count + 1;
                end else begin
                    // Emit the current run
                    length <= count;
                    bit_out <= state;
                    valid <= 1;
                    count <= 1; // reset count for new bit
                    state <= data_in; // switch state
                end
            end else begin
                // Emit last run if we reach max count
                length <= count;
                bit_out <= state;
                valid <= 1;
                count <= 0; // reset count
                state <= data_in; // switch state
            end
        end
    end
endmodule