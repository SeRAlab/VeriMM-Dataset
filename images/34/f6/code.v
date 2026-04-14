module FlashCell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D; // Write data on WE
        end
    end

    always @(posedge RE) begin
        // Read data on RE
        if (RE) begin
            // Q will hold the last written value
        end
    end
endmodule