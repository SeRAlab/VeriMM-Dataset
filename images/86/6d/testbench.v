`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] ctrl;
    reg [7:0] num1;
    reg [7:0] num2;
    reg reset;
    wire [7:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .num1(num1),
        .num2(num2),
        .reset(reset),
        .res(res)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin
            @(posedge reset);
            @(negedge reset);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (15 + 25)", test_num);
            num1 = 8'd15;
            num2 = 8'd25;
            ctrl = 2'b00;
            reset_dut();
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow (200 + 100)", test_num);
            num1 = 8'd200;
            num2 = 8'd100;
            ctrl = 2'b00;
            reset_dut();
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (100 - 30)", test_num);
            num1 = 8'd100;
            num2 = 8'd30;
            ctrl = 2'b01;
            reset_dut();
            #1;

            check_outputs(8'd70);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Underflow (20 - 50)", test_num);
            num1 = 8'd20;
            num2 = 8'd50;
            ctrl = 2'b01;
            reset_dut();
            #1;

            check_outputs(8'd226);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication (12 * 8)", test_num);
            num1 = 8'd12;
            num2 = 8'd8;
            ctrl = 2'b10;
            reset_dut();
            #1;

            check_outputs(8'd96);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication Overflow (50 * 10)", test_num);
            num1 = 8'd50;
            num2 = 8'd10;
            ctrl = 2'b10;
            reset_dut();
            #1;

            check_outputs(8'd244);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division (100 / 4)", test_num);
            num1 = 8'd100;
            num2 = 8'd4;
            ctrl = 2'b11;
            reset_dut();
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division Floor (10 / 3)", test_num);
            num1 = 8'd10;
            num2 = 8'd3;
            ctrl = 2'b11;
            reset_dut();
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Divide by Zero (50 / 0)", test_num);
            num1 = 8'd50;
            num2 = 8'd0;
            ctrl = 2'b11;
            reset_dut();
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State Verification", test_num);
            num1 = 8'hFF;
            num2 = 8'hFF;
            ctrl = 2'b00;


            @(posedge reset);
            #1;
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_res;
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
        $dumpvars(0,ctrl, num1, num2, reset, res);
    end

endmodule
