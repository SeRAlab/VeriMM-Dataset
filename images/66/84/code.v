module top_module(
    input clk,

    input start,
    output reg done,
    input [10:0] count,
    input [7:0] data_in,

    output reg [10:0] address,
    output reg enable,
    output reg [3:0] data_out
);reg [10:0] byte_count;
    reg [1:0] state;

    always @(posedge clk) begin
        case(state)
            2'b00: begin // Idle
                if(start) begin
                    state <= 2'b01; // Send LSB
                    byte_count <= 11'd0;
                end
            end
            2'b01: begin // Send LSB
                enable <= 1'b1;
                data_out <= data_in[3:0];
                address <= byte_count;
                byte_count <= byte_count + 11'd1;
                if(byte_count == count) begin
                    state <= 2'b10; // Send MSB
                end
            end
            2'b10: begin // Send MSB
                data_out <= data_in[7:4];
                address <= byte_count;
                byte_count <= byte_count + 11'd1;
                if(byte_count == count) begin
                    state <= 2'b11; // Done
                end else begin
                    state <= 2'b01; // Send LSB
                end
            end
            2'b11: begin // Done
                enable <= 1'b0;
                done <= 1'b1;
                byte_count <= 11'd0;
                if(!start) begin
                    state <= 2'b00; // Idle
                    done <= 1'b0;
                end
            end
        endcase
    end

endmodule