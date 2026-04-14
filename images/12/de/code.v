module ARQ_System (
    input wire [4:0] data_in,
    input wire ack,
    input wire clk,
    output reg [4:0] data_out
);
    reg [4:0] last_data;

    always @(posedge clk) begin
        if (ack) begin
            data_out <= data_in;
            last_data <= data_in;
        end else begin
            data_out <= last_data;
        end
    end
endmodule