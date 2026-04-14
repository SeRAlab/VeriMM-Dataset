module data_bus_controller (
    input wire [31:0] data_in,
    input wire valid,
    output reg [31:0] data_out
);
    always @(posedge valid) begin
        if (valid) begin
            data_out <= data_in;
        end else begin
            data_out <= 32'b0;
        end
    end
endmodule