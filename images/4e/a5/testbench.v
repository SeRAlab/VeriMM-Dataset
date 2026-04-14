`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [17:0] SW;
    reg clk;
    reg rst;
    wire [4:0] number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW(SW),
        .clk(clk),
        .rst(rst),
        .number(number)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        SW = 18'h0;
        rst = 0;
        @(posedge clk);
        #1 rst = 1;

    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Checking reset state", test_num);
        reset_dut();

        #1;


        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Checking increment to 10", test_num);
        reset_dut();
        SW[0] = 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Checking max value (23)", test_num);
        reset_dut();
        repeat(23) @(posedge clk);
        #1;
        #1;

        check_outputs(5'd23);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Checking wrap-around (23->0)", test_num);
        reset_dut();
        repeat(24) @(posedge clk);
        #1;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Checking hold behavior", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        SW[0] = 1;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(5'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Resuming after hold", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        SW[0] = 1;
        repeat(5) @(posedge clk);
        SW[0] = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(5'd8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Hold at boundary (23)", test_num);
        reset_dut();
        repeat(23) @(posedge clk);
        SW[0] = 1;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(5'd23);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Double wrap check", test_num);
        reset_dut();
        repeat(26) @(posedge clk);
        #1;
        #1;

        check_outputs(5'd2);
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
        input [4:0] expected_number;
        begin
            if (expected_number === (expected_number ^ number ^ expected_number)) begin
                $display("PASS");
                $display("  Outputs: number=%h",
                         number);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: number=%h",
                         expected_number);
                $display("  Got:      number=%h",
                         number);
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
        $dumpvars(0,SW, clk, rst, number);
    end

endmodule
