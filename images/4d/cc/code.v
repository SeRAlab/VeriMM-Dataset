module top_module(clk, Ram_STB, Ram_ACK);input clk;
    input Ram_STB;
    output reg Ram_ACK;

    reg [5: 0] cnt = 0;
    always @(posedge clk) begin
        if (Ram_STB) begin
            if (cnt == 2) begin
                cnt <= 0;
                Ram_ACK <= 1;
            end else begin
                cnt <= cnt + 1;
                Ram_ACK <= 0;
            end
        end else begin
            cnt <= 0;
            Ram_ACK <= 0;
        end
    end
endmodule