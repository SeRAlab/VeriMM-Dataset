`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg [1:0] op;
    reg reset;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .op(op),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            a = 0;
            b = 0;
            op = 0;
            @(negedge clk);
            reset = 0;


        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Addition (15 + 25)", test_num);
            reset_dut();
            @(negedge clk);
            a = 32'd15;
            b = 32'd25;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Subtraction (100 - 37)", test_num);
            reset_dut();
            @(negedge clk);
            a = 32'd100;
            b = 32'd37;
            op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd63);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiplication (12 * 11)", test_num);
            reset_dut();
            @(negedge clk);
            a = 32'd12;
            b = 32'd11;
            op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd132);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Division (144 / 12)", test_num);
            reset_dut();
            @(negedge clk);
            a = 32'd144;
            b = 32'd12;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Addition Overflow (0xFFFFFFFF + 1)", test_num);
            reset_dut();
            @(negedge clk);
            a = 32'hFFFFFFFF;
            b = 32'd1;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Subtraction Underflow (5 - 10)", test_num);
            reset_dut();
            @(negedge clk);
            a = 32'd5;
            b = 32'd10;
            op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Large Multiplication Truncation", test_num);
            reset_dut();
            @(negedge clk);
            a = 32'h10000;
            b = 32'h10000;
            op = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Division result < 1 (5 / 10)", test_num);
            reset_dut();
            @(negedge clk);
            a = 32'd5;
            b = 32'd10;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Operation update from non-zero state", test_num);
            reset_dut();
            @(negedge clk);
            a = 32'd10; b = 32'd20; op = 2'b00;
            @(posedge clk);
            @(negedge clk);
            a = 32'd50; b = 32'd10; op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd40);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Synchronous Reset override", test_num);
            reset_dut();
            @(negedge clk);
            a = 32'd100;
            b = 32'd100;
            op = 2'b00;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
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
        input [31:0] expected_result;
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
        $dumpvars(0,a, b, clk, op, reset, result);
    end

endmodule
