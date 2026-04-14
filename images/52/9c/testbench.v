`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] Tx;
    reg clock;
    reg [3:0] entrada;
    wire [3:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Tx(Tx),
        .clock(clock),
        .entrada(entrada),
        .X(X)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            Tx = TX_CLEAR;
            entrada = 4'b0000;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: LOAD functionality (Input 4'hA)", test_num);
            reset_dut();
            @(negedge clock);
            Tx = TX_LOAD;
            entrada = 4'hA;
            @(posedge clock);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: HOLD functionality (Hold 4'h5)", test_num);
            reset_dut();

            @(negedge clock);
            Tx = TX_LOAD;
            entrada = 4'h5;
            @(posedge clock);

            @(negedge clock);
            Tx = TX_HOLD;
            entrada = 4'hF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: CLEAR functionality after LOAD", test_num);
            reset_dut();

            @(negedge clock);
            Tx = TX_LOAD;
            entrada = 4'hF;
            @(posedge clock);

            @(negedge clock);
            Tx = TX_CLEAR;
            @(posedge clock);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Multiple LOAD operations", test_num);
            reset_dut();

            @(negedge clock);
            Tx = TX_LOAD;
            entrada = 4'h3;
            @(posedge clock);

            @(negedge clock);
            Tx = TX_LOAD;
            entrada = 4'hC;
            @(posedge clock);
            #1;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: HOLD after CLEAR", test_num);
            reset_dut();
            @(negedge clock);
            Tx = TX_HOLD;
            entrada = 4'h7;
            @(posedge clock);
            #1;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_X;
        begin
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%h",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h",
                         expected_X);
                $display("  Got:      X=%h",
                         X);
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
        $dumpvars(0,Tx, clock, entrada, X);
    end

endmodule
