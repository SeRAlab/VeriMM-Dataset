`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] k_next;
    reg [255:0] rx_state;
    reg [31:0] rx_t1_part;
    reg [31:0] rx_w1;
    wire [255:0] tx_state;
    wire [31:0] tx_t1_part;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .k_next(k_next),
        .rx_state(rx_state),
        .rx_t1_part(rx_t1_part),
        .rx_w1(rx_w1),
        .tx_state(tx_state),
        .tx_t1_part(tx_t1_part)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            k_next = 0;
            rx_state = 0;
            rx_t1_part = 0;
            rx_w1 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            rx_state = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;
            k_next = 32'h428a2f98;
            rx_w1 = 32'h00000000;

            rx_t1_part = 32'h16EDA03C;

            @(posedge clk);
            #1;


            #1;



            check_outputs(256'hCE47B18A6A09E667BB67AE853C6EF372FEC7C50E510E527F9B05688C1F83D9AB, 32'h0A4E90CC);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            rx_state = 256'h0;
            k_next = 32'h0;
            rx_w1 = 32'h0;
            rx_t1_part = 32'h0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(256'h0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            rx_state = {8{32'hFFFFFFFF}};
            k_next = 32'hFFFFFFFF;
            rx_w1 = 32'hFFFFFFFF;
            rx_t1_part = 32'hFFFFFFFF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(256'hFFFFFFFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFFFFFFFFFFFFFFFFFFFFFFFF, 32'h3FFFFF5E);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            rx_state = 256'h0000000100000000000000000000000000000000000000000000000000000000;
            k_next = 0;
            rx_w1 = 0;
            rx_t1_part = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(256'h4008040000000001000000000000000000000000000000000000000000000000, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            rx_state = 256'h0000000000000000000000000000000000000001000000000000000000000000;
            rx_t1_part = 32'h04200080;
            k_next = 0;
            rx_w1 = 0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(256'h0420008000000000000000000000000004200080000000010000000000000000, 32'h0010C400);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [255:0] expected_tx_state;
        input [31:0] expected_tx_t1_part;
        begin
            if (expected_tx_state === (expected_tx_state ^ tx_state ^ expected_tx_state) &&
                expected_tx_t1_part === (expected_tx_t1_part ^ tx_t1_part ^ expected_tx_t1_part)) begin
                $display("PASS");
                $display("  Outputs: tx_state=%h, tx_t1_part=%h",
                         tx_state, tx_t1_part);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_state=%h, tx_t1_part=%h",
                         expected_tx_state, expected_tx_t1_part);
                $display("  Got:      tx_state=%h, tx_t1_part=%h",
                         tx_state, tx_t1_part);
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
        $dumpvars(0,clk, k_next, rx_state, rx_t1_part, rx_w1, tx_state, tx_t1_part);
    end

endmodule
