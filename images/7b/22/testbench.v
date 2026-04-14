`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in1;
    reg [15:0] in2;
    wire [16:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in1 = 0;
            in2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in1 = 16'sd10;
            in2 = 16'sd20;
            @(posedge clk);
            #1;
            $display("Testcase %0d: 10 + 20", test_num);
            #1;

            check_outputs(17'sd30);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in1 = -16'sd10;
            in2 = -16'sd20;
            @(posedge clk);
            #1;
            $display("Testcase %0d: -10 + -20", test_num);
            #1;

            check_outputs(-17'sd30);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            in1 = 16'sd1000;
            in2 = -16'sd500;
            @(posedge clk);
            #1;
            $display("Testcase %0d: 1000 + -500", test_num);
            #1;

            check_outputs(17'sd500);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in1 = 16'sh7FFF;
            in2 = 16'sh7FFF;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Max Positive Addition", test_num);
            #1;

            check_outputs(17'sh0FFFE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            in1 = 16'sh8000;
            in2 = 16'sh8000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Max Negative Addition", test_num);
            #1;

            check_outputs(17'sh10000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            in1 = 16'sd0;
            in2 = 16'sd0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Zero Addition", test_num);
            #1;

            check_outputs(17'sd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            in1 = -16'sd1;
            in2 = 16'sd1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: -1 + 1", test_num);
            #1;

            check_outputs(17'sd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            in1 = 16'sd32767;
            in2 = 16'sd1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Sign boundary check (32767 + 1)", test_num);
            #1;

            check_outputs(17'sd32768);
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
        testcase008();
        
        
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
        input [16:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in1, in2, out);
    end

endmodule
