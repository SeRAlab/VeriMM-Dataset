module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q);reg [3:0] q_temp;

    always @(posedge clk or negedge areset) begin
        if (areset == 0) begin
            q_temp <= 4'b0000;
        end else if (load) begin
            q_temp <= data;
        end else if (ena) begin
            q_temp <= {q_temp[2:0], 1'b0};
        end
    end

    assign q = q_temp;

endmodule