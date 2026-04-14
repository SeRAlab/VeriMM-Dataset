`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg in_i;
    reg rst_i;
    wire out_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .in_i(in_i),
        .rst_i(rst_i),
        .out_o(out_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

    begin
        rst_i = 1;
        in_i = 0;
        @(posedge clk_i);
        #1 rst_i = 0;
        @(posedge clk_i);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Basic sequence '01'", test_num);
        reset_dut();
        in_i = 0; @(posedge clk_i);
        in_i = 1; @(posedge clk_i);
        #1 #1;
 check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Incorrect sequence '00'", test_num);
        reset_dut();
        in_i = 0; @(posedge clk_i);
        in_i = 0; @(posedge clk_i);
        #1 #1;
 check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Incorrect sequence '11'", test_num);
        reset_dut();
        in_i = 1; @(posedge clk_i);
        in_i = 1; @(posedge clk_i);
        #1 #1;
 check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Sequence '1101'", test_num);
        reset_dut();
        in_i = 1; @(posedge clk_i);
        in_i = 1; @(posedge clk_i);
        in_i = 0; @(posedge clk_i);
        in_i = 1; @(posedge clk_i);
        #1 #1;
 check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Consecutive sequences '0101'", test_num);
        reset_dut();
        in_i = 0; @(posedge clk_i);
        in_i = 1; @(posedge clk_i);
        in_i = 0; @(posedge clk_i);
        in_i = 1; @(posedge clk_i);
        #1 #1;
 check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Reset mid-sequence", test_num);
        reset_dut();
        in_i = 0; @(posedge clk_i);
        rst_i = 1; @(posedge clk_i);
        #1 rst_i = 0;
        in_i = 1; @(posedge clk_i);
        #1 #1;
 check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Sequence '0001'", test_num);
        reset_dut();
        in_i = 0; @(posedge clk_i);
        in_i = 0; @(posedge clk_i);
        in_i = 0; @(posedge clk_i);
        in_i = 1; @(posedge clk_i);
        #1 #1;
 check_outputs(1);
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
        input expected_out_o;
        begin
            if (expected_out_o === (expected_out_o ^ out_o ^ expected_out_o)) begin
                $display("PASS");
                $display("  Outputs: out_o=%b",
                         out_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_o=%b",
                         expected_out_o);
                $display("  Got:      out_o=%b",
                         out_o);
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
        $dumpvars(0,clk_i, in_i, rst_i, out_o);
    end

endmodule
