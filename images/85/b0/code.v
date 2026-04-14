module top_module(

    RX_CLK_COR_CNT,
    CHANNEL_BOND_LOAD,
    USER_CLK

);`define DLY #1

//******************************Parameter Declarations*******************************

    parameter CHANNEL_BOND_LOAD_CODE = 3'b101;     // Code indicating channel bond load complete


//***********************************Port Declarations*******************************

    input   [2:0]   RX_CLK_COR_CNT;

    output reg        CHANNEL_BOND_LOAD; // Changed to output reg

    input           USER_CLK;


//**************************Internal Register Declarations****************************

    reg             [2:0] count_reg;       // Counter for RX_CLK_COR_CNT
    reg             [2:0] prev_count_reg;  // Counter for previous RX_CLK_COR_CNT
    reg             load_complete;        // Flag for channel bond load complete


//*********************************Main Body of Code**********************************

    always @(posedge USER_CLK) begin
        prev_count_reg <= count_reg;    // Update previous counter value
        count_reg <= RX_CLK_COR_CNT;    // Update current counter value

        if (RX_CLK_COR_CNT == CHANNEL_BOND_LOAD_CODE) begin
            load_complete <= 1;         // Set flag if code received
        end else begin
            load_complete <= 0;         // Clear flag if code not received
        end
    end

    always @(posedge USER_CLK) begin
        if (count_reg > prev_count_reg) begin
            CHANNEL_BOND_LOAD <= load_complete;  // Output flag if rising edge detected
        end
    end

endmodule