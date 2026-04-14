`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg LOAD;
    reg [11:0] SEED;
    wire [11:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .LOAD(LOAD),
        .SEED(SEED),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LOAD = 1;
            SEED = 12'h000;
            #2;
            LOAD = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            LOAD = 1;
            SEED = 12'hA5A;
            #1;
            #1;

            check_outputs(12'hA5A);
            LOAD = 0;
            #1;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            LOAD = 1;
            SEED = 12'h001;
            @(posedge CLK);
            #1 LOAD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(12'h800);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            LOAD = 1;
            SEED = 12'h002;
            @(posedge CLK);
            #1 LOAD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(12'h801);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            LOAD = 1;
            SEED = 12'h053;
            @(posedge CLK);
            #1 LOAD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(12'h029);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            LOAD = 1;
            SEED = 12'hFFF;
            @(posedge CLK);
            #1 LOAD = 0;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(12'h3FF);
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
        input [11:0] expected_Q;
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
        $dumpvars(0,CLK, LOAD, SEED, Q);
    end

endmodule
