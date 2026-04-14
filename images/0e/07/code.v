module bluetooth_module (
    input wire clk,
    input wire reset,
    input wire conn_req,
    output reg connected
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            connected <= 0;
        end else if (conn_req) begin
            connected <= 1;
        end
    end
endmodule