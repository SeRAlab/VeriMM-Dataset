module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [7:0] d, // 8-bit input for the register
    input select, // Select input to choose between register and counter
    output reg [7:0] q // 8-bit output from the active module
);reg [3:0] counter;
reg [7:0] register;

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'd0;
        register <= 8'h34;
    end else begin
        if (select) begin // Register selected
            register <= d;
        end else begin // Counter selected
            if (counter == 4'd15) begin
                counter <= 4'd0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
end

always @(posedge clk) begin
    if (select) begin // Register selected
        q <= register;
    end else begin // Counter selected
        q <= {1'b0, counter};
    end
end

endmodule