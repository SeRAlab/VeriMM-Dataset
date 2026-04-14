module flash_memory_cell(
    input wire ctrl,
    input wire data_in,
    output reg data_out
);

always @(*) begin
    if (ctrl) begin
        data_out = data_in; // Store input when control is high
    end
    // No else needed as data_out will hold its previous value when ctrl is low
end

endmodule