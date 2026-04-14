module top_module(
    output reg [1:0] grant,
    input [1:0] request,
    input clk,
    input reset_n
);reg [1:0] counter;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        counter <= 2'b00;
        grant <= 2'b00;
    end else if (request != 2'b11) begin
        counter <= 2'b00;
        grant <= request;
    end else begin
        if (counter == 2'b00) begin
            grant <= 2'b01;
            counter <= 2'b01;
        end else begin
            grant <= 2'b10;
            counter <= 2'b00;
        end
    end
end

endmodule