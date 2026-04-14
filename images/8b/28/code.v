module johnson_counter (
    input clk,
    input reset,
    output reg [1:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b00;
        end else begin
            count <= {count[0], ~count[1]};
        end
    end
endmodule