module preset_register (
    input clk,
    input preset,
    input load,
    input [5:0] data_in,
    input [5:0] preset_value,
    output reg [5:0] data_out);

    always @(posedge clk) begin
        if (preset) begin
            data_out <= preset_value;
        end else if (load) begin
            data_out <= data_in;
        end
    end
endmodule