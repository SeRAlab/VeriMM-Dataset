`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg mode;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .mode(mode),
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
            mode = 0;

            repeat(3) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 8'd15;
            b = 8'd10;
            mode = 1'b0;

            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Test %0d: Addition 15 + 10", test_num);
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 8'd50;
            b = 8'd20;
            mode = 1'b1;

            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Test %0d: Subtraction 50 - 20", test_num);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 8'hFF;
            b = 8'h01;
            mode = 1'b0;

            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Test %0d: Addition Overflow (255 + 1)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 8'h00;
            b = 8'h01;
            mode = 1'b1;

            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Test %0d: Subtraction Underflow (0 - 1)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 8'd0;
            b = 8'd0;
            mode = 1'b0;

            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Test %0d: Zero Addition", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 8'd128;
            b = 8'd128;
            mode = 1'b1;

            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Test %0d: Zero Subtraction", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 8'd10;
            b = 8'd10;
            mode = 1'b0;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Test %0d: Reset Stage (Stage 3 check)", test_num);
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_result;
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
        $dumpvars(0,a, b, clk, mode, result);
    end

endmodule
