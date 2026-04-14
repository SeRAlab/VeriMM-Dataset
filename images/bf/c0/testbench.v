`timescale 1ns/1ps

module usbf_sie_ep_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg rst_i;
    reg rx_ack_i;
    reg rx_crc_err_i;
    reg [7:0] rx_data_i;
    reg rx_full_i;
    reg rx_last_i;
    reg rx_setup_i;
    reg rx_strb_i;
    reg rx_valid_i;
    reg tx_data_accept_i;
    reg [7:0] tx_data_i;
    reg tx_empty_i;
    reg tx_flush_i;
    reg [10:0] tx_length_i;
    reg tx_start_i;
    wire [7:0] rx_data_o;
    wire rx_err_o;
    wire [10:0] rx_length_o;
    wire rx_push_o;
    wire rx_ready_o;
    wire rx_setup_o;
    wire rx_space_o;
    wire tx_busy_o;
    wire tx_data_last_o;
    wire [7:0] tx_data_o;
    wire tx_data_strb_o;
    wire tx_data_valid_o;
    wire tx_err_o;
    wire tx_pop_o;
    wire tx_ready_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    usbf_sie_ep dut (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .rx_ack_i(rx_ack_i),
        .rx_crc_err_i(rx_crc_err_i),
        .rx_data_i(rx_data_i),
        .rx_full_i(rx_full_i),
        .rx_last_i(rx_last_i),
        .rx_setup_i(rx_setup_i),
        .rx_strb_i(rx_strb_i),
        .rx_valid_i(rx_valid_i),
        .tx_data_accept_i(tx_data_accept_i),
        .tx_data_i(tx_data_i),
        .tx_empty_i(tx_empty_i),
        .tx_flush_i(tx_flush_i),
        .tx_length_i(tx_length_i),
        .tx_start_i(tx_start_i),
        .rx_data_o(rx_data_o),
        .rx_err_o(rx_err_o),
        .rx_length_o(rx_length_o),
        .rx_push_o(rx_push_o),
        .rx_ready_o(rx_ready_o),
        .rx_setup_o(rx_setup_o),
        .rx_space_o(rx_space_o),
        .tx_busy_o(tx_busy_o),
        .tx_data_last_o(tx_data_last_o),
        .tx_data_o(tx_data_o),
        .tx_data_strb_o(tx_data_strb_o),
        .tx_data_valid_o(tx_data_valid_o),
        .tx_err_o(tx_err_o),
        .tx_pop_o(tx_pop_o),
        .tx_ready_o(tx_ready_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            rx_ack_i = 0;
            rx_crc_err_i = 0;
            rx_data_i = 8'h0;
            rx_full_i = 0;
            rx_last_i = 0;
            rx_setup_i = 0;
            rx_strb_i = 0;
            rx_valid_i = 0;
            tx_data_accept_i = 0;
            tx_data_i = 8'h0;
            tx_empty_i = 1;
            tx_flush_i = 0;
            tx_length_i = 11'h0;
            tx_start_i = 0;
            repeat(5) @(posedge clk_i);
            rst_i = 0;
            @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Receive SETUP Packet");
            reset_dut();
            rx_setup_i = 1;
            rx_valid_i = 1;


            repeat(8) begin
                rx_data_i = $random;
                rx_strb_i = 1;
                @(posedge clk_i);
                rx_strb_i = 0;
                @(posedge clk_i);
            end

            rx_last_i = 1;
            rx_valid_i = 1;
            @(posedge clk_i);
            rx_last_i = 0;
            rx_valid_i = 0;
            rx_setup_i = 0;

            repeat(2) @(posedge clk_i);


            #1;



            check_outputs(8'h0, 0, 11'd8, 0, 1, 1, 1, 0, 0, 8'h0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Receive 4-byte DATA Packet");
            reset_dut();
            rx_setup_i = 0;
            rx_valid_i = 1;

            repeat(4) begin
                rx_data_i = 8'hA5;
                rx_strb_i = 1;
                @(posedge clk_i);
                rx_strb_i = 0;
                @(posedge clk_i);
            end

            rx_last_i = 1;
            @(posedge clk_i);
            rx_last_i = 0;
            rx_valid_i = 0;

            repeat(2) @(posedge clk_i);


            #1;



            check_outputs(8'h0, 0, 11'd4, 0, 1, 0, 1, 0, 0, 8'h0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Receive with CRC Error");
            reset_dut();
            rx_valid_i = 1;
            rx_data_i = 8'hFF;
            rx_strb_i = 1;
            @(posedge clk_i);
            rx_strb_i = 0;
            rx_last_i = 1;
            rx_crc_err_i = 1;
            @(posedge clk_i);
            rx_last_i = 0;
            rx_valid_i = 0;
            rx_crc_err_i = 0;

            repeat(2) @(posedge clk_i);


            #1;



            check_outputs(8'h0, 1, 11'd1, 0, 1, 0, 1, 0, 0, 8'h0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Data Transmission (2 bytes)");
            reset_dut();
            tx_length_i = 11'd2;
            tx_data_i = 8'h55;
            tx_empty_i = 0;
            tx_start_i = 1;
            @(posedge clk_i);
            tx_start_i = 0;


            wait(tx_data_valid_o);
            tx_data_accept_i = 1;
            @(posedge clk_i);
            tx_data_i = 8'hAA;
            @(posedge clk_i);
            tx_data_accept_i = 0;
            tx_empty_i = 1;

            repeat(5) @(posedge clk_i);


            #1;



            check_outputs(8'h0, 0, 11'h0, 0, 0, 0, 1, 0, 0, 8'h0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Transmit Flush");
            reset_dut();
            tx_length_i = 11'd10;
            tx_start_i = 1;
            @(posedge clk_i);
            tx_start_i = 0;
            @(posedge clk_i);

            tx_flush_i = 1;
            @(posedge clk_i);
            tx_flush_i = 0;

            repeat(2) @(posedge clk_i);


            #1;



            check_outputs(8'h0, 0, 11'h0, 0, 0, 0, 1, 0, 0, 8'h0, 0, 0, 0, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("usbf_sie_ep Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [7:0] expected_rx_data_o;
        input expected_rx_err_o;
        input [10:0] expected_rx_length_o;
        input expected_rx_push_o;
        input expected_rx_ready_o;
        input expected_rx_setup_o;
        input expected_rx_space_o;
        input expected_tx_busy_o;
        input expected_tx_data_last_o;
        input [7:0] expected_tx_data_o;
        input expected_tx_data_strb_o;
        input expected_tx_data_valid_o;
        input expected_tx_err_o;
        input expected_tx_pop_o;
        input expected_tx_ready_o;
        begin
            if (expected_rx_data_o === (expected_rx_data_o ^ rx_data_o ^ expected_rx_data_o) &&
                expected_rx_err_o === (expected_rx_err_o ^ rx_err_o ^ expected_rx_err_o) &&
                expected_rx_length_o === (expected_rx_length_o ^ rx_length_o ^ expected_rx_length_o) &&
                expected_rx_push_o === (expected_rx_push_o ^ rx_push_o ^ expected_rx_push_o) &&
                expected_rx_ready_o === (expected_rx_ready_o ^ rx_ready_o ^ expected_rx_ready_o) &&
                expected_rx_setup_o === (expected_rx_setup_o ^ rx_setup_o ^ expected_rx_setup_o) &&
                expected_rx_space_o === (expected_rx_space_o ^ rx_space_o ^ expected_rx_space_o) &&
                expected_tx_busy_o === (expected_tx_busy_o ^ tx_busy_o ^ expected_tx_busy_o) &&
                expected_tx_data_last_o === (expected_tx_data_last_o ^ tx_data_last_o ^ expected_tx_data_last_o) &&
                expected_tx_data_o === (expected_tx_data_o ^ tx_data_o ^ expected_tx_data_o) &&
                expected_tx_data_strb_o === (expected_tx_data_strb_o ^ tx_data_strb_o ^ expected_tx_data_strb_o) &&
                expected_tx_data_valid_o === (expected_tx_data_valid_o ^ tx_data_valid_o ^ expected_tx_data_valid_o) &&
                expected_tx_err_o === (expected_tx_err_o ^ tx_err_o ^ expected_tx_err_o) &&
                expected_tx_pop_o === (expected_tx_pop_o ^ tx_pop_o ^ expected_tx_pop_o) &&
                expected_tx_ready_o === (expected_tx_ready_o ^ tx_ready_o ^ expected_tx_ready_o)) begin
                $display("PASS");
                $display("  Outputs: rx_data_o=%h, rx_err_o=%b, rx_length_o=%h, rx_push_o=%b, rx_ready_o=%b, rx_setup_o=%b, rx_space_o=%b, tx_busy_o=%b, tx_data_last_o=%b, tx_data_o=%h, tx_data_strb_o=%b, tx_data_valid_o=%b, tx_err_o=%b, tx_pop_o=%b, tx_ready_o=%b",
                         rx_data_o, rx_err_o, rx_length_o, rx_push_o, rx_ready_o, rx_setup_o, rx_space_o, tx_busy_o, tx_data_last_o, tx_data_o, tx_data_strb_o, tx_data_valid_o, tx_err_o, tx_pop_o, tx_ready_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_data_o=%h, rx_err_o=%b, rx_length_o=%h, rx_push_o=%b, rx_ready_o=%b, rx_setup_o=%b, rx_space_o=%b, tx_busy_o=%b, tx_data_last_o=%b, tx_data_o=%h, tx_data_strb_o=%b, tx_data_valid_o=%b, tx_err_o=%b, tx_pop_o=%b, tx_ready_o=%b",
                         expected_rx_data_o, expected_rx_err_o, expected_rx_length_o, expected_rx_push_o, expected_rx_ready_o, expected_rx_setup_o, expected_rx_space_o, expected_tx_busy_o, expected_tx_data_last_o, expected_tx_data_o, expected_tx_data_strb_o, expected_tx_data_valid_o, expected_tx_err_o, expected_tx_pop_o, expected_tx_ready_o);
                $display("  Got:      rx_data_o=%h, rx_err_o=%b, rx_length_o=%h, rx_push_o=%b, rx_ready_o=%b, rx_setup_o=%b, rx_space_o=%b, tx_busy_o=%b, tx_data_last_o=%b, tx_data_o=%h, tx_data_strb_o=%b, tx_data_valid_o=%b, tx_err_o=%b, tx_pop_o=%b, tx_ready_o=%b",
                         rx_data_o, rx_err_o, rx_length_o, rx_push_o, rx_ready_o, rx_setup_o, rx_space_o, tx_busy_o, tx_data_last_o, tx_data_o, tx_data_strb_o, tx_data_valid_o, tx_err_o, tx_pop_o, tx_ready_o);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk_i, rst_i, rx_ack_i, rx_crc_err_i, rx_data_i, rx_full_i, rx_last_i, rx_setup_i, rx_strb_i, rx_valid_i, tx_data_accept_i, tx_data_i, tx_empty_i, tx_flush_i, tx_length_i, tx_start_i, rx_data_o, rx_err_o, rx_length_o, rx_push_o, rx_ready_o, rx_setup_o, rx_space_o, tx_busy_o, tx_data_last_o, tx_data_o, tx_data_strb_o, tx_data_valid_o, tx_err_o, tx_pop_o, tx_ready_o);
    end

endmodule
