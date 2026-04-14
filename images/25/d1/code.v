module divide_by_8 (
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg [7:0] out
);
    reg [2:0] state;
    reg [7:0] temp;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0;
            state <= 3'b0;
        end else begin
            if (state == 3'b000) begin
                temp <= in;
                state <= 3'b001;
            end else if (state == 3'b001) begin
                out <= temp >> 3; // Divide by 8
                state <= 3'b000; // Go back to initial state
            end
        end
    end
endmodule