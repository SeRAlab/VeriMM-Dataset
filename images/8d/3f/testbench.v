`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg clk;
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
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a <= 16'd0;
        b <= 16'd0;
        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: 12 * 15", test_num);
        a <= 16'd12;
        b <= 16'd15;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(32'd180);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: -10 * 20", test_num);
        a <= -16'd10;
        b <= 16'd20;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(-32'd200);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: 50 * -4", test_num);
        a <= 16'd50;
        b <= -16'd4;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(-32'd200);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: -15 * -10", test_num);
        a <= -16'd15;
        b <= -16'd10;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(32'd150);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: 0 * 999", test_num);
        a <= 16'd0;
        b <= 16'd999;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: -123 * 1", test_num);
        a <= -16'd123;
        b <= 16'd1;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(-32'd123);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: 32767 * 2", test_num);
        a <= 16'h7FFF;
        b <= 16'd2;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(32'd65534);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: -32768 * 2", test_num);
        a <= 16'h8000;
        b <= 16'd2;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(-32'd65536);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: 1000 * 1000", test_num);
        a <= 16'd1000;
        b <= 16'd1000;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(32'd1000000);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: -32768 * -1", test_num);
        a <= 16'h8000;
        b <= -16'd1;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(32'd32768);
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
        $dumpvars(0,a, b, clk, result);
    end

endmodule
