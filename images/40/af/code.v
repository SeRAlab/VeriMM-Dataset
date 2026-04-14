module pulse_generator(
    input wire clk,
    input wire start,
    input wire [3:0] N,
    output reg pulse
);
    reg [3:0] count;
    reg generating;

    always @(posedge clk) begin
        if (start) begin
            generating <= 1'b1;
            count <= N;
            pulse <= 1'b1;
        end else if (generating) begin
            if (count > 0) begin
                count <= count - 1;
            end else begin
                generating <= 1'b0;
                pulse <= 1'b0;
            end
        end
    end
endmodule