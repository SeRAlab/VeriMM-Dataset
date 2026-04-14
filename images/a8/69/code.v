module top_module(
    input clk,
    input reset,
    input sel,
    input [5:0] addr,
    input w,
    input [197:0] data,
    output reg [197:0] out,
    output reg done
);reg [197:0] mem[63:0];

always @(posedge clk) begin
    if (reset) begin
        done <= 0;
        out <= 0;
    end else begin
        if (sel) begin
            if (w) begin
                mem[addr] <= data;
                done <= 1;
            end else begin
                out <= mem[addr];
                done <= 1;
            end
        end else begin
            done <= 0;
        end
    end
end

endmodule