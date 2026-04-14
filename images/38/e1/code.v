module DAC_Controller (
    input [15:0] data_in,
    output reg [15:0] data_out
);
    always @* begin
        data_out = data_in; // Pass-through for DAC
    end
endmodule