`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] rx_round;
    wire [3:0] tx_s0;
    wire [3:0] tx_s1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rx_round(rx_round),
        .tx_s0(tx_s0),
        .tx_s1(tx_s1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rx_round = 0;
            @(posedge clk);
            rx_round = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            rx_round = 7'h0A;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            rx_round = 7'h05;
            @(posedge clk);

            rx_round = 7'h0E;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hE, 4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            rx_round = 7'h7F;
            @(posedge clk);

            rx_round = 7'h00;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            rx_round = 7'h21; @(posedge clk);
            rx_round = 7'h32; @(posedge clk);
            rx_round = 7'h43; @(posedge clk);
            #1;

            #1;


            check_outputs(4'h3, 4'h2);
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
        input [3:0] expected_tx_s0;
        input [3:0] expected_tx_s1;
        begin
            if (expected_tx_s0 === (expected_tx_s0 ^ tx_s0 ^ expected_tx_s0) &&
                expected_tx_s1 === (expected_tx_s1 ^ tx_s1 ^ expected_tx_s1)) begin
                $display("PASS");
                $display("  Outputs: tx_s0=%h, tx_s1=%h",
                         tx_s0, tx_s1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_s0=%h, tx_s1=%h",
                         expected_tx_s0, expected_tx_s1);
                $display("  Got:      tx_s0=%h, tx_s1=%h",
                         tx_s0, tx_s1);
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
        $dumpvars(0,clk, rx_round, tx_s0, tx_s1);
    end

endmodule
