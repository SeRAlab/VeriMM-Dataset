module top_module(
    input CLK_A,        // Clock for domain A
    input CLK_A_SEND,   // Signal from domain A to domain B
    output CLK_A_RECV,  // Signal from domain B received in domain A 
    input CLK_B,        // Clock for domain B
    input CLK_B_SEND,   // Signal from domain B to domain A
    output CLK_B_RECV,  // Signal from domain A received in domain B
    output ERR          // Error output
);reg a_send_sync;
    reg b_send_sync;
    reg a_send_sync_ff;
    reg b_send_sync_ff;

    assign CLK_A_RECV = b_send_sync;
    assign CLK_B_RECV = a_send_sync;

    always @(posedge CLK_A) begin
        a_send_sync <= CLK_A_SEND;
        b_send_sync_ff <= b_send_sync;
        b_send_sync <= b_send_sync_ff;
    end

    always @(posedge CLK_B) begin
        a_send_sync_ff <= a_send_sync; // Corrected the order of assignments
        a_send_sync <= CLK_B_SEND;      // Corrected the assignment to CLK_B_SEND
    end

    assign ERR = (CLK_A_SEND & CLK_B_SEND) | (~CLK_A_SEND & ~CLK_B_SEND);

endmodule