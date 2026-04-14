module sample_rate_converter (
    input clk,
    input rst,
    input [7:0] in_data,
    input in_valid,
    output reg [7:0] out_data,
    output reg out_valid
);
    reg [1:0] state;
    parameter IDLE = 2'b00, CONVERT = 2'b01, OUTPUT = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            out_data <= 8'b0;
            out_valid <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in_valid) begin
                        state <= CONVERT;
                    end
                end
                CONVERT: begin
                    // Upsampling by storing the incoming data
                    out_data <= in_data; // Implementing 2x upsampling
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    out_valid <= 1'b1; // Output valid for one clock cycle
                    state <= IDLE; // Return to idle state
                end
            endcase
        end
    end
endmodule