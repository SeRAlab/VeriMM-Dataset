module top_module(clk, rst_n, out);input clk, rst_n;
    output [3:0] out;

    reg [3:0] count;

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            count <= 4'b0;
        end else begin
            if(count == 4'b1111) begin
                count <= 4'b0;
            end else begin
                count <= count + 1;
            end
        end
    end

    assign out = count;

endmodule