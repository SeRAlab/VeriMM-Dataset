module ARQ(
    input wire [4:0] data_in,
    input wire ack,
    output reg [4:0] data_out,
    output reg send
);
    always @(posedge ack or negedge ack) begin
        if (ack) begin
            data_out <= data_in; // Acknowledged data
            send <= 1; // Send new data
        end else begin
            send <= 0; // Hold the previous data
        end
    end
endmodule