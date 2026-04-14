`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg LLbit_i;
    reg clk;
    reg flush;
    reg rst;
    reg we;
    wire LLbit_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LLbit_i(LLbit_i),
        .clk(clk),
        .flush(flush),
        .rst(rst),
        .we(we),
        .LLbit_o(LLbit_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        flush = 0;
        LLbit_i = 0;
        we = 0;
        #15;
        rst = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Write 1", test_num);
        reset_dut();

        @(posedge clk);
        #1;
        we = 1;
        LLbit_i = 1;
        @(posedge clk);
        #1;
        we = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write Enable Low Check", test_num);
        reset_dut();

        @(posedge clk);
        #1;
        we = 0;
        LLbit_i = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Asynchronous Flush Check", test_num);
        reset_dut();


        @(posedge clk);
        #1;
        we = 1;
        LLbit_i = 1;
        @(posedge clk);
        #1;
        we = 0;


        flush = 1;
        #2;
        #1;

        check_outputs(1'b0);
        flush = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Data Holding Check", test_num);
        reset_dut();


        @(posedge clk);
        #1;
        we = 1;
        LLbit_i = 1;
        @(posedge clk);
        #1;

        we = 0;
        LLbit_i = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Flush Priority Check", test_num);
        reset_dut();

        @(posedge clk);
        #1;
        we = 1;
        LLbit_i = 1;
        flush = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
        flush = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write 0 Check", test_num);
        reset_dut();


        @(posedge clk);
        #1; we = 1; LLbit_i = 1;
        @(posedge clk);
        #1;

        LLbit_i = 0;
        @(posedge clk);
        #1;
        we = 0;
        #1;

        check_outputs(1'b0);
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
        input expected_LLbit_o;
        begin
            if (expected_LLbit_o === (expected_LLbit_o ^ LLbit_o ^ expected_LLbit_o)) begin
                $display("PASS");
                $display("  Outputs: LLbit_o=%b",
                         LLbit_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LLbit_o=%b",
                         expected_LLbit_o);
                $display("  Got:      LLbit_o=%b",
                         LLbit_o);
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
        $dumpvars(0,LLbit_i, clk, flush, rst, we, LLbit_o);
    end

endmodule
