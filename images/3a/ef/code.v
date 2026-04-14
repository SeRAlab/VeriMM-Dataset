module FlashMemoryController (
    input [4:0] data_in,
    input control,
    output reg [4:0] data_out
);
    always @(*) begin
        if (control) begin
            data_out = data_in; // Output data when control is high
        end else begin
            data_out = 5'b00000; // Output zeros when control is low
        end
    end
endmodule