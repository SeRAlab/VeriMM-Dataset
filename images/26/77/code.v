module shift_register (
    input wire clk,
    input wire load,
    input wire [3:0] data_in,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (load) begin
            q <= data_in;  // Load new data
        end else begin
            q <= {q[2:0], 1'b0};  // Shift left
        end
    end
endmodule