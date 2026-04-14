`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg [31:0] ctrl_word;
    wire out_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_ref(clk_ref),
        .ctrl_word(ctrl_word),
        .out_clk(out_clk)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

    begin
        ctrl_word = 32'h0;

        repeat(5) @(posedge clk_ref);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Ctrl=2, check toggle after 2 cycles", test_num);
        reset_dut();
        ctrl_word = 32'd2;
        repeat(2) @(posedge clk_ref);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Ctrl=2, check full period (toggle back) after 4 cycles", test_num);
        reset_dut();
        ctrl_word = 32'd2;
        repeat(4) @(posedge clk_ref);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Ctrl=10, check toggle after 10 cycles", test_num);
        reset_dut();
        ctrl_word = 32'd10;
        repeat(10) @(posedge clk_ref);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Ctrl=10, check full period after 20 cycles", test_num);
        reset_dut();
        ctrl_word = 32'd10;
        repeat(20) @(posedge clk_ref);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Ctrl=100, check toggle after 100 cycles", test_num);
        reset_dut();
        ctrl_word = 32'd100;
        repeat(100) @(posedge clk_ref);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Ctrl=1, check toggle every cycle", test_num);
        reset_dut();
        ctrl_word = 32'd1;
        repeat(1) @(posedge clk_ref);
        #1;
        #1;

        check_outputs(1'b1);
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
        input expected_out_clk;
        begin
            if (expected_out_clk === (expected_out_clk ^ out_clk ^ expected_out_clk)) begin
                $display("PASS");
                $display("  Outputs: out_clk=%b",
                         out_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_clk=%b",
                         expected_out_clk);
                $display("  Got:      out_clk=%b",
                         out_clk);
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
        $dumpvars(0,clk_ref, ctrl_word, out_clk);
    end

endmodule
