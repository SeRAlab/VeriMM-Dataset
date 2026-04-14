`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] max;
    reg [7:0] min;
    reg prevConfigInvalid;
    reg rst;
    reg [31:0] test_expr;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .max(max),
        .min(min),
        .prevConfigInvalid(prevConfigInvalid),
        .rst(rst),
        .test_expr(test_expr),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            min = 0;
            max = 0;
            test_expr = 0;
            prevConfigInvalid = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Expression in range (Middle)", test_num);
            reset_dut();
            min = 8'd10;
            max = 8'd50;
            test_expr = 32'd30;
            prevConfigInvalid = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Expression at minimum boundary (Inclusive)", test_num);
            reset_dut();
            min = 8'd10;
            max = 8'd50;
            test_expr = 32'd10;
            prevConfigInvalid = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Expression at maximum boundary (Inclusive)", test_num);
            reset_dut();
            min = 8'd10;
            max = 8'd50;
            test_expr = 32'd50;
            prevConfigInvalid = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Expression below range", test_num);
            reset_dut();
            min = 8'd10;
            max = 8'd50;
            test_expr = 32'd9;
            prevConfigInvalid = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Expression above range", test_num);
            reset_dut();
            min = 8'd10;
            max = 8'd50;
            test_expr = 32'd51;
            prevConfigInvalid = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Configuration Invalid Flag", test_num);
            reset_dut();
            min = 8'd10;
            max = 8'd50;
            test_expr = 32'd30;
            prevConfigInvalid = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large 32-bit value (Out of 8-bit range)", test_num);
            reset_dut();
            min = 8'd0;
            max = 8'd255;
            test_expr = 32'h0000_0100;
            prevConfigInvalid = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Min > Max scenario", test_num);
            reset_dut();
            min = 8'd100;
            max = 8'd50;
            test_expr = 32'd75;
            prevConfigInvalid = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
        $dumpvars(0,clk, max, min, prevConfigInvalid, rst, test_expr, out);
    end

endmodule
