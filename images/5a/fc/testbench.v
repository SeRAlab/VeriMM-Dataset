`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg halt;
    reg resume;
    reg rst_n;
    wire en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .halt(halt),
        .resume(resume),
        .rst_n(rst_n),
        .en(en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            resume = 0;
            halt = 0;
            @(posedge clk);
            #2;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset behavior", test_num);
            reset_dut();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Halt signal effect", test_num);
            reset_dut();
            halt = 1;
            @(posedge clk);
            #2;
            halt = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Resume signal effect after halt", test_num);
            reset_dut();
            halt = 1;
            @(posedge clk);
            #2;
            halt = 0;
            resume = 1;
            @(posedge clk);
            #2;
            resume = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Maintaining LOW state", test_num);
            reset_dut();
            halt = 1;
            @(posedge clk);
            #2;
            halt = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Simultaneous resume and halt", test_num);
            reset_dut();
            halt = 1;
            @(posedge clk);
            #2;

            resume = 1;
            halt = 1;
            @(posedge clk);
            #2;
            resume = 0;
            halt = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Reset dominance over halt", test_num);
            reset_dut();
            halt = 1;
            @(posedge clk);
            #2;
            rst_n = 0;
            @(posedge clk);
            #2;
            rst_n = 1;
            halt = 0;
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
        input expected_en;
        begin
            if (expected_en === (expected_en ^ en ^ expected_en)) begin
                $display("PASS");
                $display("  Outputs: en=%b",
                         en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en=%b",
                         expected_en);
                $display("  Got:      en=%b",
                         en);
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
        $dumpvars(0,clk, halt, resume, rst_n, en);
    end

endmodule
