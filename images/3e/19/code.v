module pcie_completer(
    input wire [7:0] req_id,
    input wire [15:0] data_in,
    output wire [7:0] resp_id,
    output wire [15:0] data_out
);
    assign resp_id = req_id;
    assign data_out = data_in + 1;
endmodule