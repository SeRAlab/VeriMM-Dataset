module edge_detector (
    input wire clk,
    input wire rst,
    input wire signal_in,
    output reg edge_out
);
    reg signal_in_d;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            edge_out <= 0;
            signal_in_d <= 0;
        end else begin
            edge_out <= (signal_in && !signal_in_d);
            signal_in_d <= signal_in;
        end
    end
endmodule