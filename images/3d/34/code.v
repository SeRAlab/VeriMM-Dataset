module sample_rate_converter(
    input wire clk,
    input wire reset,
    input wire [7:0] sample_in,
    output reg [7:0] sample_out
);
    reg [1:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            sample_out <= 8'b0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'b01) begin
                sample_out <= sample_in;
            end
        end
    end
endmodule