module sample_rate_converter(
    input wire clk,
    input wire audio_in,
    output reg audio_out
);
    reg [1:0] count;

    always @(posedge clk) begin
        count <= count + 1;
        if (count == 2) begin
            audio_out <= audio_in;
            count <= 0;
        end
    end
endmodule