module pcie_interface (
    input [4:0] address,
    input [4:0] data_in,
    output reg [4:0] data_out
);

    parameter PREDEFINED_ADDRESS = 5'b10101;

    always @(*) begin
        if (address == PREDEFINED_ADDRESS)
            data_out = data_in;
        else
            data_out = 5'b00000;
    end
endmodule