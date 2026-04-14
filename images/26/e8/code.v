module sd_card_controller(
    input wire clk,
    input wire reset,
    input wire [1:0] operation,
    input wire [7:0] data_input,
    output reg status
);
    reg [7:0] data_storage;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            status <= 0;
            data_storage <= 8'b0;
        end else begin
            case (operation)
                2'b01: begin // READ
                    // Simulate reading data
                    status <= (data_storage != 8'b0) ? 1 : 0;
                end
                2'b10: begin // WRITE
                    // Simulate writing data
                    data_storage <= data_input;
                    status <= 1; // Assume write is always successful
                end
                default: begin // IDLE
                    status <= 0;
                end
            endcase
        end
    end
endmodule