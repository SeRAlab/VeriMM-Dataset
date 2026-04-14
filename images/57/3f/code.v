module up_counter_toggle (
    input clk,
    input en,
    input toggle,
    output reg [2:0] count);

    always @(posedge clk) begin
        if (en) begin
            if (toggle) begin
                count <= (count == 3'b000) ? 3'b001 : 3'b000;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule