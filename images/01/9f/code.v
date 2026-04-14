module deserializer (
    input wire clk,
    input wire rst,
    input wire valid,
    input wire [7:0] data_in,
    output reg [15:0] data_out,
    output reg data_valid
);

    reg [7:0] temp_data;
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 16'b0;
            temp_data <= 8'b0;
            data_valid <= 1'b0;
            state <= 2'b00;
        end else if (valid) begin
            case (state)
                2'b00: begin
                    temp_data <= data_in;
                    state <= 2'b01;
                    data_valid <= 1'b0;
                end
                2'b01: begin
                    data_out <= {data_in, temp_data}; // Concatenate new data with previous
                    data_valid <= 1'b1;
                    state <= 2'b10;
                end
                2'b10: begin
                    data_valid <= 1'b0; // Hold valid low until next valid input
                    state <= 2'b00; // Reset to initial state
                end
            endcase
        end
    end
endmodule