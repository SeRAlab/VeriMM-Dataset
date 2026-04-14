`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir_in;
    reg [14:0] para_in;
    reg rst;
    wire dir_out;
    wire en_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir_in(dir_in),
        .para_in(para_in),
        .rst(rst),
        .dir_out(dir_out),
        .en_out(en_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            para_in = 0;
            dir_in = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            para_in = 15'd0;
            dir_in = 0;
            #20;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            para_in = 15'h7FFF;
            dir_in = 1;
            #20;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            para_in = 15'd100;
            dir_in = 0;
            #20;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            para_in = 15'd5000;
            dir_in = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            para_in = 15'h4000;
            dir_in = 1;
            #10;
            dir_in = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_dir_out;
        input expected_en_out;
        begin
            if (expected_dir_out === (expected_dir_out ^ dir_out ^ expected_dir_out) &&
                expected_en_out === (expected_en_out ^ en_out ^ expected_en_out)) begin
                $display("PASS");
                $display("  Outputs: dir_out=%b, en_out=%b",
                         dir_out, en_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dir_out=%b, en_out=%b",
                         expected_dir_out, expected_en_out);
                $display("  Got:      dir_out=%b, en_out=%b",
                         dir_out, en_out);
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
        $dumpvars(0,clk, dir_in, para_in, rst, dir_out, en_out);
    end

endmodule
