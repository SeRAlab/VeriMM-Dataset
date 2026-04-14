module ARQ_System (
    input wire clk,
    input wire rst,
    input wire [4:0] data_in,
    input wire ack,
    output reg [4:0] data_out
);
    reg [4:0] last_data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 5'b00000; // Reset output
            last_data <= 5'b00000; // Reset last data
        end else begin
            if (ack) begin
                data_out <= data_in; // Send new data
                last_data <= data_in; // Update last data
            end else begin
                data_out <= last_data; // Re-transmit last data
            end
        end
    end
endmodule