`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg clk;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a <= 0;
        b <= 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Positive * Positive", test_num);
        a <= 16'sd100;
        b <= 16'sd200;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'sd20000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Negative * Positive", test_num);
        a <= -16'sd50;
        b <= 16'sd10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(-32'sd500);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Positive * Negative", test_num);
        a <= 16'sd15;
        b <= -16'sd30;
        @(posedge clk);
        #1;
        #1;

        check_outputs(-32'sd450);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Negative * Negative", test_num);
        a <= -16'sd12;
        b <= -16'sd12;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'sd144);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication by Zero", test_num);
        a <= 16'sd0;
        b <= -16'sd1234;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'sd0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Max Positive Square", test_num);
        a <= 16'sh7FFF;
        b <= 16'sh7FFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'sd1073676289);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Min Negative Square", test_num);
        a <= 16'sh8000;
        b <= 16'sh8000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'sd1073741824);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Min Negative * Max Positive", test_num);
        a <= 16'sh8000;
        b <= 16'sh7FFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(-32'sd1073709056);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Identity", test_num);
        a <= 16'sd1;
        b <= -16'sd999;
        @(posedge clk);
        #1;
        #1;

        check_outputs(-32'sd999);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplier -1", test_num);
        a <= -16'sd1;
        b <= -16'sd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'sd1);
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
        input [31:0] expected_out;
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
        $dumpvars(0,a, b, clk, out);
    end

endmodule
