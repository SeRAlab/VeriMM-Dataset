`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 8'd0;
            b = 8'd0;
            repeat (10) @(posedge clk);
            $display("Test %0d: 0 * 0", test_num);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 8'd0;
            b = 8'd255;
            repeat (10) @(posedge clk);
            $display("Test %0d: 0 * 255", test_num);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 8'd1;
            b = 8'd1;
            repeat (10) @(posedge clk);
            $display("Test %0d: 1 * 1", test_num);
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 8'd255;
            b = 8'd1;
            repeat (10) @(posedge clk);
            $display("Test %0d: 255 * 1", test_num);
            #1;

            check_outputs(16'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 8'd16;
            b = 8'd16;
            repeat (10) @(posedge clk);
            $display("Test %0d: 16 * 16", test_num);
            #1;

            check_outputs(16'd256);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 8'd123;
            b = 8'd45;
            repeat (10) @(posedge clk);
            $display("Test %0d: 123 * 45", test_num);
            #1;

            check_outputs(16'd5535);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            a = 8'b10101010;
            b = 8'b01010101;
            repeat (10) @(posedge clk);
            $display("Test %0d: 170 * 85", test_num);
            #1;

            check_outputs(16'd14450);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            a = 8'd255;
            b = 8'd255;
            repeat (10) @(posedge clk);
            $display("Test %0d: 255 * 255", test_num);
            #1;

            check_outputs(16'd65025);
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
        input [15:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,a, b, clk, result);
    end

endmodule
