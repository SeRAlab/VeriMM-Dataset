module round_robin_arbiter(
    input wire clk,
    input wire reset,
    input wire [3:0] request,
    output reg [3:0] grant
);
    reg [1:0] curr_pointer;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            curr_pointer <= 2'b00;
            grant <= 4'b0000;
        end else begin
            if (request) begin
                grant <= 4'b0000; // reset grants
                grant[curr_pointer] <= 1'b1; // grant current pointer
                curr_pointer <= (curr_pointer + 1) % 4; // round-robin
            end else begin
                grant <= 4'b0000; // no request
            end
        end
    end
endmodule