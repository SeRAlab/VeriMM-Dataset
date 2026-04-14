module wifi_controller(
    input wire clk,
    input wire request,
    output reg connected
);

    always @(posedge clk) begin
        if (request) begin
            connected <= 1'b1;
        end else begin
            connected <= 1'b0;
        end
    end

endmodule