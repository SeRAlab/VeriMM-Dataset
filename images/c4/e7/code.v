module counter(input clk, reset, load, input [3:0] data, output reg [3:0] count);

    always @(posedge clk, negedge reset) begin
        if (~reset) begin
            count <= 4'b0000;
        end else if (load) begin
            count <= data;
        end else begin
            count <= count + 1;
        end
    end

endmodule