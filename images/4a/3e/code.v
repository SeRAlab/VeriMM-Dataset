module top_module(
    input clk, 
    input reset,
    input [3:0] reg_data_in,
    input reg_load,
    input counter_enable,
    output [7:0] output_data
);reg [3:0] register_data;
reg [3:0] counter_data;
wire [7:0] xor_output;

// Register module
always @(posedge clk, negedge reset) begin
    if (!reset) begin
        register_data <= 4'b0;
    end else begin
        if (reg_load) begin
            register_data <= reg_data_in;
        end
    end
end

// Counter module
always @(posedge clk, negedge reset) begin
    if (!reset) begin
        counter_data <= 4'b0;
    end else begin
        if (counter_enable) begin
            counter_data <= counter_data + 1;
        end
    end
end

// XOR module
assign xor_output = {register_data, counter_data} ^ 8'b11111111;

// Output
assign output_data = xor_output;

endmodule