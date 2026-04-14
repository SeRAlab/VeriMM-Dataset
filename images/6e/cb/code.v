module top_module(
    input CLK,
    input RESET,
    input LOAD,
    input [3:0] DATA,
    input SHIFT_ENABLE,
    output reg SERIAL_OUT
);reg [3:0] counter;
reg [3:0] shift_register;
reg [3:0] sum;

always @(posedge CLK) begin
    if (RESET) begin
        counter <= 4'b0000;
        shift_register <= 4'b0000;
        sum <= 4'b0000;
        SERIAL_OUT <= 1'b0;
    end
    else begin
        if (LOAD) begin
            counter <= DATA;
        end
        else begin
            if (counter == 4'b1001) begin
                counter <= 4'b0000;
            end
            else begin
                counter <= counter + 1;
            end
        end
        
        if (SHIFT_ENABLE) begin
            SERIAL_OUT <= shift_register[0];
            shift_register <= {shift_register[3:1], counter};
        end
        else begin
            sum <= counter + shift_register;
            SERIAL_OUT <= sum[0];
        end
    end
end

endmodule