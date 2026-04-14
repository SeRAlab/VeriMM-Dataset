module sd_card_controller (
    input wire clk,
    input wire reset,
    input wire start_read,
    output reg [7:0] data_out,
    output reg data_valid
);
    reg [3:0] state;
    reg [7:0] data_register;

    parameter IDLE = 4'b0000,
              READ = 4'b0001,
              VALIDATE = 4'b0010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_out <= 8'b0;
            data_valid <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start_read) begin
                        state <= READ;
                    end
                end
                READ: begin
                    // Simulated read from SD card
                    data_register <= $random; // Replace this with actual read logic
                    state <= VALIDATE;
                end
                VALIDATE: begin
                    data_out <= data_register;
                    data_valid <= 1;
                    state <= IDLE; // Go back to IDLE after reading
                end
            endcase
        end
    end
endmodule