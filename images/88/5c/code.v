module top_module(
  input clk,
  input rst,
  output reg clk_breath
);parameter max_breath = 640000;
    reg [31:0] counter1;
    reg [31:0] counter2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter1 <= 0;
            counter2 <= 0;
            clk_breath <= 0;
        end
        else begin
            if (counter1 == max_breath/2 - 1) begin
                counter1 <= counter1 + 1;
			    clk_breath <= 1;
		    end
            else if (counter1 == max_breath - 1) begin
                counter1 <= 0;
                clk_breath <= 0;
            end
            else begin
                counter1 <= counter1 + 1;
                clk_breath <= clk_breath;
            end
        end
    end

endmodule