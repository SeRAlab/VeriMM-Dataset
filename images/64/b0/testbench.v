`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg SI;
    wire Q3;
    wire SO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .SI(SI),
        .Q3(Q3),
        .SO(SO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            SI = 0;
            repeat(4) @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Shift in 1 followed by three 0s", test_num);
            reset_dut();

            @(negedge CLK); SI = 1;
            @(negedge CLK); SI = 0;
            @(negedge CLK); SI = 0;
            @(negedge CLK); SI = 0;

            @(posedge CLK); #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Shift in all 1s", test_num);
            reset_dut();

            repeat(4) begin
                @(negedge CLK); SI = 1;
            end

            @(posedge CLK); #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Pattern 1-0-1-0", test_num);
            reset_dut();

            @(negedge CLK); SI = 1;
            @(negedge CLK); SI = 0;
            @(negedge CLK); SI = 1;
            @(negedge CLK); SI = 0;

            @(posedge CLK); #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Pattern 0-1-1-1", test_num);
            reset_dut();

            @(negedge CLK); SI = 0;
            @(negedge CLK); SI = 1;
            @(negedge CLK); SI = 1;
            @(negedge CLK); SI = 1;

            @(posedge CLK); #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Pattern 1-1-0-0", test_num);
            reset_dut();

            @(negedge CLK); SI = 1;
            @(negedge CLK); SI = 1;
            @(negedge CLK); SI = 0;
            @(negedge CLK); SI = 0;

            @(posedge CLK); #2;
            #1;

            check_outputs(0, 1);
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
        input expected_Q3;
        input expected_SO;
        begin
            if (expected_Q3 === (expected_Q3 ^ Q3 ^ expected_Q3) &&
                expected_SO === (expected_SO ^ SO ^ expected_SO)) begin
                $display("PASS");
                $display("  Outputs: Q3=%b, SO=%b",
                         Q3, SO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q3=%b, SO=%b",
                         expected_Q3, expected_SO);
                $display("  Got:      Q3=%b, SO=%b",
                         Q3, SO);
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
        $dumpvars(0,CLK, SI, Q3, SO);
    end

endmodule
