`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg reset;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .reset(reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            reset = 1;
            #15;
            reset = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking Reset State...");
            reset = 1;
            #10;

            #1;


            check_outputs(4'h0);
            reset = 0;
            #5;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Transition after 1 Clock Cycle...");
            reset_dut();


            #1;



            check_outputs(Q);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Sequence progression after 5 cycles...");
            reset_dut();
            repeat(4) @(posedge CLK);
            #2;

            #1;


            check_outputs(Q);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Asynchronous reset mid-operation...");
            reset_dut();
            repeat(3) @(posedge CLK);
            #3;
            reset = 1;
            #1;

            #1;


            check_outputs(4'h0);
            reset = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: State stability between clock edges...");
            reset_dut();
            @(posedge CLK);
            #2;
            reg [3:0] capture;
            capture = Q;
            #5;
            if (Q === capture) begin
                #1;

                check_outputs(capture);
            end else begin
                $display("FAIL: State changed without clock edge");
                fail_count = fail_count + 1;
            end
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, reset, Q);
    end

endmodule
