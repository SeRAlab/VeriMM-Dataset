`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] mode;
    reg [7:0] num1;
    reg [7:0] num2;
    reg start;
    wire done;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mode(mode),
        .num1(num1),
        .num2(num2),
        .start(start),
        .done(done),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            mode = 0;
            num1 = 0;
            num2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (15 + 25)", test_num);
            reset_dut();
            num1 = 8'd15;
            num2 = 8'd25;
            mode = 2'b00;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow (250 + 10)", test_num);
            reset_dut();
            num1 = 8'd250;
            num2 = 8'd10;
            mode = 2'b00;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (100 - 40)", test_num);
            reset_dut();
            num1 = 8'd100;
            num2 = 8'd40;
            mode = 2'b01;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Negative (10 - 20)", test_num);
            reset_dut();
            num1 = 8'd10;
            num2 = 8'd20;
            mode = 2'b01;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'hF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication (12 * 5)", test_num);
            reset_dut();
            num1 = 8'd12;
            num2 = 8'd5;
            mode = 2'b10;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'd60);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication Overflow (20 * 20)", test_num);
            reset_dut();
            num1 = 8'd20;
            num2 = 8'd20;
            mode = 2'b10;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'd144);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division (100 / 4)", test_num);
            reset_dut();
            num1 = 8'd100;
            num2 = 8'd4;
            mode = 2'b11;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'd25);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division Floor (7 / 2)", test_num);
            reset_dut();
            num1 = 8'd7;
            num2 = 8'd2;
            mode = 2'b11;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Start Inactive Check", test_num);
            reset_dut();
            num1 = 8'd10;
            num2 = 8'd10;
            mode = 2'b00;
            start = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'bxxxx_xxxx);
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
        input expected_done;
        input [7:0] expected_result;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: done=%b, result=%h",
                         done, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, result=%h",
                         expected_done, expected_result);
                $display("  Got:      done=%b, result=%h",
                         done, result);
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
        $dumpvars(0,clk, mode, num1, num2, start, done, result);
    end

endmodule
