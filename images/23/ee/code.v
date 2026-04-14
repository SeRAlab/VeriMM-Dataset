module sram_cell (
    input [3:0] data_in,
    input WE, // Write Enable
    input EN, // Enable
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(*) begin
        if (EN) begin
            if (WE) begin
                storage = data_in; // Store data when WE is high
            end
        end
    end

    always @(*) begin
        if (EN && !WE) begin
            data_out = storage; // Read stored data when WE is low
        end else begin
            data_out = 4'bz; // High-impedance state when EN is low
        end
    end
endmodule