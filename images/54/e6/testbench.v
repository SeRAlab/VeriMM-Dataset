`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] in1;
    reg [23:0] in2;
    wire [47:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .res(res)
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
            test_num = 1;
            reset_dut();
            in1 = 24'd1000;
            in2 = 24'd2000;
            @(posedge clk);
            #1;
            $display("Test Case 001: 1000 * 2000");
            #1;

            check_outputs(48'd2000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            in1 = 24'd150;
            in2 = -24'd300;
            @(posedge clk);
            #1;
            $display("Test Case 002: 150 * -300");
            #1;

            check_outputs(-48'd45000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in1 = -24'd500;
            in2 = -24'd400;
            @(posedge clk);
            #1;
            $display("Test Case 003: -500 * -400");
            #1;

            check_outputs(48'd200000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in1 = 24'h7FFFFF;
            in2 = 24'd0;
            @(posedge clk);
            #1;
            $display("Test Case 004: Max Positive * 0");
            #1;

            check_outputs(48'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in1 = 24'h7FFFFF;
            in2 = 24'h7FFFFF;
            @(posedge clk);
            #1;
            $display("Test Case 005: 8388607 * 8388607");

            #1;


            check_outputs(48'h3FFFFF000001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            in1 = 24'h800000;
            in2 = 24'h800000;
            @(posedge clk);
            #1;
            $display("Test Case 006: -8388608 * -8388608");

            #1;


            check_outputs(48'h400000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            in1 = 24'h800000;
            in2 = 24'h7FFFFF;
            @(posedge clk);
            #1;
            $display("Test Case 007: -8388608 * 8388607");

            #1;


            check_outputs(48'hC00000800000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            in1 = 24'sd1234567;
            in2 = -24'sd1;
            @(posedge clk);
            #1;
            $display("Test Case 008: 1234567 * -1");
            #1;

            check_outputs(-48'sd1234567);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            in1 = -24'sd1;
            in2 = -24'sd1;
            @(posedge clk);
            #1;
            $display("Test Case 009: -1 * -1");
            #1;

            check_outputs(48'sd1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            in1 = 24'h800000;
            in2 = 24'd1;
            @(posedge clk);
            #1;
            $display("Test Case 010: Min 24-bit * 1");
            #1;

            check_outputs(48'hFFFFFFFF800000);
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
        input [47:0] expected_res;
        begin
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
        $dumpvars(0,clk, in1, in2, res);
    end

endmodule
