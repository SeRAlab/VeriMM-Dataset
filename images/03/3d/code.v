module johnson_counter(
    input wire clk,
    input wire reset,
    output reg [4:0] Q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 5'b00000;
        end else begin
            Q <= {Q[3:0], ~Q[4]};
        end
    end
endmodule