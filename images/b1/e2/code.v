module top_module(
    input [3:0] LOAD,
    input UP_DOWN,
    input CLK,
    input RESET,
    input [3:0] D,
    output reg [3:0] OUT
);reg [3:0] up_down_counter;
reg [3:0] shift_register;

always @(posedge CLK) begin
    if (RESET) begin
        up_down_counter <= 4'b0;
        shift_register <= 4'b0;
        OUT <= 4'b0;
    end
    else if (LOAD) begin
        up_down_counter <= LOAD;
        shift_register <= D;
        OUT <= up_down_counter + shift_register;
    end
    else begin
        if (UP_DOWN) begin
            up_down_counter <= up_down_counter + 1;
        end
        else begin
            up_down_counter <= up_down_counter - 1;
        end
        shift_register <= {shift_register[2:0], D[0]};
        OUT <= up_down_counter + shift_register;
    end
end

endmodule