module linear_voltage_regulator (
    input wire clk,
    input wire rst,
    input wire [7:0] vin, // Input voltage
    input wire [1:0] ctrl, // Control signal to set output voltage
    output reg [7:0] vout // Output voltage
);

    // State encoding
    parameter STATE_IDLE = 2'b00;
    parameter STATE_SET_1 = 2'b01;
    parameter STATE_SET_2 = 2'b10;
    parameter STATE_SET_3 = 2'b11;

    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            vout <= 8'b0;
            state <= STATE_IDLE;
        end else begin
            case (state)
                STATE_IDLE: begin
                    if (ctrl == 2'b01) begin
                        state <= STATE_SET_1;
                    end else if (ctrl == 2'b10) begin
                        state <= STATE_SET_2;
                    end else if (ctrl == 2'b11) begin
                        state <= STATE_SET_3;
                    end
                end
                STATE_SET_1: begin
                    vout <= vin > 8'd50 ? 8'd50 : vin; // Set output to 50 if vin > 50
                    state <= STATE_IDLE;
                end
                STATE_SET_2: begin
                    vout <= vin > 8'd100 ? 8'd100 : vin; // Set output to 100 if vin > 100
                    state <= STATE_IDLE;
                end
                STATE_SET_3: begin
                    vout <= vin > 8'd150 ? 8'd150 : vin; // Set output to 150 if vin > 150
                    state <= STATE_IDLE;
                end
                default: state <= STATE_IDLE;
            endcase
        end
    end
endmodule