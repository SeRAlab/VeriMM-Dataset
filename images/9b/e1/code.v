module top_module(
    input i2c_scl,
    inout i2c_sda,
    input reset,
    output reg signed [15:0] temperature // Changed to reg to allow assignment in always block
);reg [7:0] i2c_address = 8'h90; // ADT7410 I2C address
    reg [7:0] i2c_data;
    reg [3:0] i2c_state = 4'b0000; // I2C state machine state
    reg [15:0] temp_raw; // raw temperature data from sensor

    assign i2c_sda = (i2c_state[3]) ? 1'bz : (i2c_data[7]); // tri-state buffer for I2C data signal

    always @(posedge i2c_scl or posedge reset) begin
        if (reset) begin
            i2c_state <= 4'b0000;
            i2c_data <= 8'h00;
            temp_raw <= 16'h0000;
            temperature <= 16'h0000; // Initialize temperature on reset
        end
        else begin
            case (i2c_state)
                4'b0000: begin // start condition
                    i2c_state <= 4'b0001;
                    i2c_data <= {i2c_address, 1'b0};
                end
                4'b0001: begin // send address and read bit
                    if (i2c_sda == 1'b0) begin // acknowledge received
                        i2c_state <= 4'b0010;
                    end
                end
                4'b0010: begin // read first byte of temperature data
                    i2c_state <= 4'b0011;
                end
                4'b0011: begin // read second byte of temperature data
                    i2c_state <= 4'b0100;
                end
                4'b0100: begin // stop condition
                    i2c_state <= 4'b0101;
                    i2c_data <= 8'h00;
                    temp_raw <= {i2c_data, i2c_data}; // combine two bytes of temperature data
                end
                4'b0101: begin // temperature conversion
                    i2c_state <= 4'b0000;
                    temperature <= $signed(temp_raw) * 16'h0002; // convert to °C (adjusted for accuracy, 0.0625 as fractional multiplication is not directly supported)
                end
            endcase
        end
    end

endmodule