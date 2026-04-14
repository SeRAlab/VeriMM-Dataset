module top_module(
    input clk,
    input slowena,
    input reset,
    output [3:0] q);reg [3:0] count;
    
    assign q = count;
    
    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end
        else begin
            if (slowena) begin 
                if (count < 9)
                    count <= count + 1;
                else
                    count <= 0;
            end
        end
    end

endmodule