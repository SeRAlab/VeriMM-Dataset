`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg cnt_finish;
    reg [3:0] cnt_len;
    reg [12:0] cnt_output;
    reg cnt_output_enable;
    reg rst;
    wire [15:0] data_o;
    wire done_o;
    wire valid_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .cnt_finish(cnt_finish),
        .cnt_len(cnt_len),
        .cnt_output(cnt_output),
        .cnt_output_enable(cnt_output_enable),
        .rst(rst),
        .data_o(data_o),
        .done_o(done_o),
        .valid_o(valid_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ce = 0;
            cnt_finish = 0;
            cnt_len = 0;
            cnt_output = 0;
            cnt_output_enable = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Check Reset state", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input 16 bits (8+8) and check validity", test_num);
            reset_dut();

            ce = 1;
            @(posedge clk);
            #1;

            cnt_output_enable = 1;
            cnt_len = 8;
            cnt_output = 13'hAB;
            @(posedge clk);
            #1;

            cnt_output_enable = 1;
            cnt_len = 8;
            cnt_output = 13'hCD;
            @(posedge clk);
            #1;
            cnt_output_enable = 0;




            #1;





            check_outputs(data_o, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Assert cnt_finish and check done_o", test_num);
            reset_dut();

            ce = 1;
            @(posedge clk);
            #1;
            cnt_output_enable = 1;
            cnt_len = 4;
            cnt_output = 13'h5;
            @(posedge clk);
            #1;
            cnt_output_enable = 0;
            cnt_finish = 1;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(data_o, 1, valid_o);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify ce=0 prevents data processing", test_num);
            reset_dut();

            ce = 0;
            @(posedge clk);
            #1;
            cnt_output_enable = 1;
            cnt_len = 16;
            cnt_output = 13'hFFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Accumulate multiple small chunks", test_num);
            reset_dut();

            ce = 1;
            cnt_output_enable = 1;
            cnt_len = 4;

            cnt_output = 13'h1; @(posedge clk); #1;
            cnt_output = 13'h2; @(posedge clk); #1;
            cnt_output = 13'h3; @(posedge clk); #1;
            cnt_output = 13'h4; @(posedge clk); #1;
            cnt_output_enable = 0;


            #1;



            check_outputs(data_o, 0, 1);
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
        input [15:0] expected_data_o;
        input expected_done_o;
        input expected_valid_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_done_o === (expected_done_o ^ done_o ^ expected_done_o) &&
                expected_valid_o === (expected_valid_o ^ valid_o ^ expected_valid_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, done_o=%b, valid_o=%b",
                         data_o, done_o, valid_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, done_o=%b, valid_o=%b",
                         expected_data_o, expected_done_o, expected_valid_o);
                $display("  Got:      data_o=%h, done_o=%b, valid_o=%b",
                         data_o, done_o, valid_o);
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
        $dumpvars(0,ce, clk, cnt_finish, cnt_len, cnt_output, cnt_output_enable, rst, data_o, done_o, valid_o);
    end

endmodule
