module current_sensor (
    input wire [4:0] current_in,
    input wire clk,
    input wire [2:0] sample_count,
    output reg [4:0] avg_current
);
    reg [4:0] sum;
    reg [3:0] count;

    always @(posedge clk) begin
        if (count < sample_count) begin
            sum <= sum + current_in;
            count <= count + 1;
        end else begin
            avg_current <= sum / sample_count;
            sum <= current_in; // reset sum with the current reading
            count <= 1; // reset count since we're starting over
        end
    end
endmodule