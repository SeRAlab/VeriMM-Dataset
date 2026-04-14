module drams_cell(
    input wire WE,   // Write Enable
    input wire WL,   // Word Line
    input wire D,    // Data Input
    output reg Q     // Data Output
);
    
    reg stored_data; // Internal register to hold the data

    always @(posedge WL) begin
        if (WE) begin
            stored_data <= D; // Store data when WE is high
        end
    end

    always @(posedge WL) begin
        if (!WE) begin
            Q <= stored_data; // Output stored data when WE is low
        end
    end

endmodule