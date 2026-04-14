module top_module(
    input clk,
    input reset,
    output reg [1:0] hour,
    output reg [5:0] minute,
    output reg ampm,
    output reg valid
);reg [3:0] hour_count;  // Changed to 4-bit to accommodate values from 1 to 12
reg [5:0] minute_count;
reg [3:0] prev_hour;   // Changed to 4-bit to accommodate values from 1 to 12
reg [5:0] prev_minute;
reg prev_ampm;
reg prev_valid;

always @(posedge clk) begin
    if (reset) begin
        hour_count <= 4'b0001; // Initialize to 1
        minute_count <= 6'b000000;
        ampm <= 1'b0;
        valid <= 1'b0;
    end else begin
        prev_hour <= hour_count;
        prev_minute <= minute_count;
        prev_ampm <= ampm;
        prev_valid <= valid;
        
        // increment minute count
        if (minute_count == 6'd59) begin
            minute_count <= 6'b000000;
            // increment hour count
            if (hour_count == 4'd12) begin
                hour_count <= 4'd1; // Reset to 1
                ampm <= ~ampm; // Toggle AM/PM
                // reset clock at 12:00 PM
                if (ampm) begin
                    valid <= 1'b0;
                    hour_count <= 4'b0001; // Set to 1
                    minute_count <= 6'b000000; // Reset minutes
                end
            end else begin
                hour_count <= hour_count + 1;
            end
        end else begin
            minute_count <= minute_count + 1;
        end
        
        // set valid flag if time is valid
        if (hour_count == 4'd12 && minute_count == 6'd00 && ampm == 1'b1) begin
            valid <= 1'b1;
        end else begin
            valid <= 1'b0;
        end
    end
end

// output hour and minute counts
assign hour = hour_count[3:2]; // If you want only top 2 bits for a 2-bit hour output
assign minute = minute_count; // Directly assign minute count

endmodule