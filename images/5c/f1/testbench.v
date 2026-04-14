`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg i_count;
    reg i_count_up;
    reg i_reset;
    wire [3:0] o_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_count(i_count),
        .i_count_up(i_count_up),
        .i_reset(i_reset),
        .o_count(o_count)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_reset = 1;
            i_count = 0;
            i_count_up = 0;
            @(posedge i_clk);
            #1;
            i_reset = 0;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count Up to 5", test_num);
            reset_dut();
            i_count = 1;
            i_count_up = 1;
            repeat(5) @(posedge i_clk);
            #1;
            i_count = 0;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count Down (Underflow 0 to 15)", test_num);
            reset_dut();
            i_count = 1;
            i_count_up = 0;
            @(posedge i_clk);
            #1;
            i_count = 0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count Up (Overflow 15 to 0)", test_num);
            reset_dut();
            i_count = 1;
            i_count_up = 1;
            repeat(16) @(posedge i_clk);
            #1;
            i_count = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count Enable Toggle", test_num);
            reset_dut();
            i_count = 1;
            i_count_up = 1;
            repeat(3) @(posedge i_clk);
            i_count = 0;
            repeat(3) @(posedge i_clk);
            #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Change Direction Mid-count", test_num);
            reset_dut();
            i_count = 1;
            i_count_up = 1;
            repeat(10) @(posedge i_clk);
            i_count_up = 0;
            repeat(4) @(posedge i_clk);
            #1;
            i_count = 0;
            #1;

            check_outputs(4'h6);
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
        input [3:0] expected_o_count;
        begin
            if (expected_o_count === (expected_o_count ^ o_count ^ expected_o_count)) begin
                $display("PASS");
                $display("  Outputs: o_count=%h",
                         o_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_count=%h",
                         expected_o_count);
                $display("  Got:      o_count=%h",
                         o_count);
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
        $dumpvars(0,i_clk, i_count, i_count_up, i_reset, o_count);
    end

endmodule
