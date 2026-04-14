`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DIR;
    reg LOAD;
    reg [3:0] MAX_COUNT;
    reg RESET;
    reg [3:0] data_in;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DIR(DIR),
        .LOAD(LOAD),
        .MAX_COUNT(MAX_COUNT),
        .RESET(RESET),
        .data_in(data_in),
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
            RESET = 1;
            LOAD = 0;
            DIR = 0;
            data_in = 4'h0;
            MAX_COUNT = 4'hF;
            @(negedge CLK);
            RESET = 0;

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset to 0", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Load Function", test_num);
            reset_dut();
            @(negedge CLK);
            LOAD = 1;
            data_in = 4'hA;
            @(negedge CLK);
            LOAD = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Up Counting (0 to 5)", test_num);
            reset_dut();
            @(negedge CLK);
            DIR = 1;
            repeat(5) @(negedge CLK);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Down Counting (Load 8 to 5)", test_num);
            reset_dut();
            @(negedge CLK);
            LOAD = 1;
            data_in = 4'h8;
            @(negedge CLK);
            LOAD = 0;
            DIR = 0;
            repeat(3) @(negedge CLK);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying MAX_COUNT Limit (Saturation at 7)", test_num);
            reset_dut();
            @(negedge CLK);
            MAX_COUNT = 4'h7;
            DIR = 1;
            repeat(10) @(negedge CLK);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Lower Limit (Saturation at 0)", test_num);
            reset_dut();
            @(negedge CLK);
            DIR = 0;
            repeat(3) @(negedge CLK);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Direction Toggle (Up 4, Down 2)", test_num);
            reset_dut();
            @(negedge CLK);
            DIR = 1;
            repeat(4) @(negedge CLK);
            DIR = 0;
            repeat(2) @(negedge CLK);
            #1;

            check_outputs(4'h2);
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
        testcase007();
        
        
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
        $dumpvars(0,CLK, DIR, LOAD, MAX_COUNT, RESET, data_in, Q);
    end

endmodule
