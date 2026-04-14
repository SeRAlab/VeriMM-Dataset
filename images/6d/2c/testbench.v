`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ena;
    reg [3:0] gray;
    reg rst;
    wire [3:0] binary;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena(ena),
        .gray(gray),
        .rst(rst),
        .binary(binary)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task init_inputs;

        begin
            ena = 0;
            gray = 0;
            rst = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray 0000 -> Binary 0000", test_num);
            reset_dut();
            ena = 1;
            gray = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray 0001 -> Binary 0001", test_num);
            reset_dut();
            ena = 1;
            gray = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray 0011 -> Binary 0010", test_num);
            reset_dut();
            ena = 1;
            gray = 4'b0011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray 1000 -> Binary 1111", test_num);
            reset_dut();
            ena = 1;
            gray = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray 1100 -> Binary 1000", test_num);
            reset_dut();
            ena = 1;
            gray = 4'b1100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Signal Low (Hold state)", test_num);
            reset_dut();

            ena = 1;
            gray = 4'b0001;
            @(posedge clk);
            #1;

            ena = 0;
            gray = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray 1010 -> Binary 1100", test_num);
            reset_dut();
            ena = 1;
            gray = 4'b1010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray 0101 -> Binary 0110", test_num);
            reset_dut();
            ena = 1;
            gray = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset priority over Enable", test_num);
            reset_dut();
            ena = 1;
            gray = 4'b1111;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
            rst = 0;
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_binary;
        begin
            if (expected_binary === (expected_binary ^ binary ^ expected_binary)) begin
                $display("PASS");
                $display("  Outputs: binary=%h",
                         binary);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary=%h",
                         expected_binary);
                $display("  Got:      binary=%h",
                         binary);
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
        $dumpvars(0,clk, ena, gray, rst, binary);
    end

endmodule
