module rle_encoder (
    input clk,
    input reset,
    input data_in,
    input start,
    output reg [7:0] encoded_value,
    output reg [7:0] count,
    output reg valid_output
);
    reg [7:0] current_count;
    reg current_value;
    reg collecting;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            encoded_value <= 0;
            count <= 0;
            valid_output <= 0;
            current_count <= 0;
            collecting <= 0;
        end else if (start) begin
            if (!collecting) begin
                current_value <= data_in;
                current_count <= 1;
                collecting <= 1;
            end else if (data_in == current_value) begin
                current_count <= current_count + 1;
            end else begin
                encoded_value <= current_value;
                count <= current_count;
                valid_output <= 1;
                current_value <= data_in;
                current_count <= 1;
            end
        end else if (collecting && !start) begin
            valid_output <= 0;
        end
    end
endmodule