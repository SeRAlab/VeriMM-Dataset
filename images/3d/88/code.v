module johnson_counter (
    input clk,
    input rst,
    output reg [4:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 5'b00000; // Reset the counter
        end else begin
            q <= {~q[4], q[4:1]}; // Johnson counter logic
        end
    end
endmodule