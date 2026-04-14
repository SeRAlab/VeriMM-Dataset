module data_power_module (
    input  A   ,
    output X   ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);

    reg [7:0] data_reg;
    wire power_wire;
    wire data_power_wire;

    always @(posedge VPB) begin
        data_reg <= A;
    end

    assign power_wire = VPWR;

    assign data_power_wire = data_reg & power_wire;

    assign X = data_power_wire;

endmodule