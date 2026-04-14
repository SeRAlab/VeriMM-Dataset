module sample_rate_converter (
    input wire clk,
    input wire rst,
    input wire [7:0] sample_in,
    output reg [7:0] sample_out,
    output reg valid_out
);
    reg [1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            sample_out <= 0;
            valid_out <= 0;
        end else begin
            if (count == 1) begin
                sample_out <= sample_in;
                valid_out <= 1;
                count <= 0;
            end else begin
                valid_out <= 0;
                count <= count + 1;
            end
        end
    end
endmodule