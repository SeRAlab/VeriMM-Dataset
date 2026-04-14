`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg load;
    reg sub;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .load(load),
        .sub(sub),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            a = 32'h0;
            b = 32'h0;
            sub = 0;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Addition", test_num);
            load = 1;
            a = 32'h00000010;
            @(posedge clk);
            #1;
            load = 0;
            b = 32'h00000020;
            sub = 0;
            #1;
            #1;

            check_outputs(32'h00000030);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Basic Subtraction", test_num);
            load = 1;
            a = 32'h00000050;
            @(posedge clk);
            #1;
            load = 0;
            b = 32'h00000020;
            sub = 1;
            #1;
            #1;

            check_outputs(32'h00000030);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Shift 1 then Add", test_num);
            load = 1;
            a = 32'h00000005;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            b = 32'h00000002;
            sub = 0;
            #1;
            #1;

            check_outputs(32'h0000000C);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Shift 3 then Subtract", test_num);
            load = 1;
            a = 32'h00000001;
            @(posedge clk);
            #1;
            load = 0;
            repeat(3) @(posedge clk);
            #1;
            b = 32'h00000003;
            sub = 1;
            #1;
            #1;

            check_outputs(32'h00000005);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Higher Bit Shift", test_num);
            load = 1;
            a = 32'h00000080;
            @(posedge clk);
            #1;
            load = 0;
            repeat(4) @(posedge clk);
            #1;
            b = 32'h00000100;
            sub = 0;
            #1;
            #1;

            check_outputs(32'h00000900);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Wrap-around Subtraction", test_num);
            load = 1;
            a = 32'h00000001;
            @(posedge clk);
            #1;
            load = 0;
            b = 32'h00000002;
            sub = 1;
            #1;

            #1;


            check_outputs(32'h0000FFFF);
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
        input [31:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,a, b, clk, load, sub, sum);
    end

endmodule
