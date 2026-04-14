module shift_register(
    input wire clk,
    input wire reset,
    input wire [1:0] data,
    output reg [1:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 2'b00;
        end else begin
            q <= {q[0], data[1]}; // Shift left and insert new data
        end
    end
endmodule