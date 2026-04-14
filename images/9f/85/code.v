module johnson_counter (
    input clk,
    input rst,
    input en,
    output reg [3:0] johnson_count);

    always @(posedge clk) begin
        if (rst) begin
            johnson_count <= 4'b0;
        end else if (en) begin
            johnson_count <= {johnson_count[2:0], ~johnson_count[3]};
        end
    end
endmodule