module data_forwarding_unit(
    input [7:0] data1,
    input [7:0] data2,
    input select,
    output reg [7:0] output_data
);
    always @(*) begin
        if (select) begin
            output_data = data2; // Forward data2
        end else begin
            output_data = data1; // Forward data1
        end
    end
endmodule