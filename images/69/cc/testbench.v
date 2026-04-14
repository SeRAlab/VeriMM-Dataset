`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DOWN;
    reg RST;
    reg UP;
    wire [3:0] CODE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DOWN(DOWN),
        .RST(RST),
        .UP(UP),
        .CODE(CODE)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 0;
            UP = 0;
            DOWN = 0;
            @(negedge CLK);
            RST = 1;
            @(negedge CLK);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            UP = 1;
            @(negedge CLK);
            UP = 0;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            UP = 1;
            repeat(2) @(negedge CLK);
            UP = 0;

            #1;


            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            DOWN = 1;
            @(negedge CLK);
            DOWN = 0;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            UP = 1;
            repeat(16) @(negedge CLK);
            UP = 0;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            UP = 1;
            repeat(5) @(negedge CLK);
            UP = 0;
            DOWN = 1;
            repeat(2) @(negedge CLK);
            DOWN = 0;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            UP = 1;
            repeat(8) @(negedge CLK);
            UP = 0;

            #1;


            check_outputs(4'b1100);
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
        input [3:0] expected_CODE;
        begin
            if (expected_CODE === (expected_CODE ^ CODE ^ expected_CODE)) begin
                $display("PASS");
                $display("  Outputs: CODE=%h",
                         CODE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CODE=%h",
                         expected_CODE);
                $display("  Got:      CODE=%h",
                         CODE);
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
        $dumpvars(0,CLK, DOWN, RST, UP, CODE);
    end

endmodule
