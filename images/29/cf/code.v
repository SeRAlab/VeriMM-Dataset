module VCO (
    input clk,
    input reset,
    input [2:0] ctrl,
    output reg out
);
    reg [2:0] count;
    reg [3:0] toggle_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 0;
            count <= 0;
            toggle_count <= 0;
        end else begin
            if (toggle_count < (1 << (ctrl + 1))) begin
                toggle_count <= toggle_count + 1;
            end else begin
                out <= ~out;
                toggle_count <= 0;
            end

            count <= count + 1;
        end
    end
endmodule