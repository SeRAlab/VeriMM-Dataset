module shift_register (
    input clk,
    input load,
    input [7:0] new_data,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (load) begin
            q <= new_data;
        end else begin
            q <= {q[6:0], 1'b0}; // Shift left and fill with 0
        end
    end
endmodule