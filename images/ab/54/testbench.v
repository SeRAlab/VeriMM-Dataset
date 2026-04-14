`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] rx_round;
    wire [31:0] tx_k0;
    wire [31:0] tx_k1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rx_round(rx_round),
        .tx_k0(tx_k0),
        .tx_k1(tx_k1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rx_round <= 7'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Round 0", test_num);
            reset_dut();
            rx_round <= 7'd0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h428a2f98, 32'h71374491);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Round 1", test_num);
            reset_dut();
            rx_round <= 7'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hb5c0fbcf, 32'he9b5dba5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Round 15", test_num);
            reset_dut();
            rx_round <= 7'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h5be0cd19, 32'h1f83d9ab);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Round 32", test_num);
            reset_dut();
            rx_round <= 7'd32;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'ha81a664b, 32'hc24b8b70);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Round 63", test_num);
            reset_dut();
            rx_round <= 7'd63;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hbe22af21, 32'h92722c85);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Check - Round 127", test_num);
            reset_dut();
            rx_round <= 7'd127;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
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
        testcase006();
        
        
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
        input [31:0] expected_tx_k0;
        input [31:0] expected_tx_k1;
        begin
            if (expected_tx_k0 === (expected_tx_k0 ^ tx_k0 ^ expected_tx_k0) &&
                expected_tx_k1 === (expected_tx_k1 ^ tx_k1 ^ expected_tx_k1)) begin
                $display("PASS");
                $display("  Outputs: tx_k0=%h, tx_k1=%h",
                         tx_k0, tx_k1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_k0=%h, tx_k1=%h",
                         expected_tx_k0, expected_tx_k1);
                $display("  Got:      tx_k0=%h, tx_k1=%h",
                         tx_k0, tx_k1);
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
        $dumpvars(0,clk, rx_round, tx_k0, tx_k1);
    end

endmodule
