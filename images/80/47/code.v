module top_module(
    input clk,
    input cein,
    input enable,
    input wdreset,
    input wdogdis,
    input [7:0] wdogdivreg,
    output wdtripce
);reg [7:0] counter = 0;
    reg wdtripce_reg = 0;
    reg wdogdis_reg = 0;
    
    assign wdtripce = wdtripce_reg;
    
    always @(*) begin
        if ((wdogdivreg == counter) && ~wdreset && enable && ~wdogdis_reg)
            wdtripce_reg <= cein;
        else
            wdtripce_reg <= 0;
    end
    
    always @(posedge clk) begin
        // Synchronize watchdog disable to clock
        wdogdis_reg <= wdogdis;
        
        if(wdogdis_reg) begin
            // Watchdog disabled, reset counter and watchdog trip signal
            counter <= 8'h00;
        end
        else if(wdreset) begin
            // Watchdog reset, reset counter and watchdog trip signal
            counter <= 8'h00;
            wdtripce_reg <= 0;
        end
        else if(enable) begin
            // Watchdog enabled
            if(counter == wdogdivreg) begin
                // Watchdog trip, set watchdog trip signal
                wdtripce_reg <= cein;
                counter <= 8'h00;
            end
            else begin
                // Watchdog not tripped, increment counter
                if(cein)
                    counter <= counter + 1;
            end
        end
        else begin
            // Watchdog disabled, reset counter and watchdog trip signal
            counter <= 8'h00;
            wdtripce_reg <= 0;
        end
    end
    
endmodule