module arq_system (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire ack,
    output reg [7:0] data_out
);

    reg [7:0] last_valid_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
            last_valid_data <= 8'b0;
        end else begin
            if (ack) begin
                data_out <= data_in; // Update output if ACK is received
                last_valid_data <= data_in; // Store last valid data
            end else begin
                data_out <= last_valid_data; // Hold last valid data if no ACK
            end
        end
    end

endmodule