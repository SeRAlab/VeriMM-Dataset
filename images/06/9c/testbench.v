`timescale 1ns/1ps

module pipelined_adder_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] a;
    reg [4:0] b;
    reg clk;
    reg rst;
    wire [5:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_adder dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        a = 0;
        b = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Running testcase001: 10 + 5");
        a = 5'd10; b = 5'd5;
        @(posedge clk);
        a = 0; b = 0;
        repeat(4) @(posedge clk);
        #2;
        #1;

        check_outputs(6'd15);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Running testcase002: 31 + 31 (Max values)");
        a = 5'd31; b = 5'd31;
        @(posedge clk);
        a = 0; b = 0;
        repeat(4) @(posedge clk);
        #2;
        #1;

        check_outputs(6'd62);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Running testcase003: 0 + 0");
        a = 5'd0; b = 5'd0;
        @(posedge clk);
        repeat(4) @(posedge clk);
        #2;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Running testcase004: 16 + 16");
        a = 5'd16; b = 5'd16;
        @(posedge clk);
        a = 0; b = 0;
        repeat(4) @(posedge clk);
        #2;
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Running testcase005: 13 + 17");
        a = 5'd13; b = 5'd17;
        @(posedge clk);
        a = 0; b = 0;
        repeat(4) @(posedge clk);
        #2;
        #1;

        check_outputs(6'd30);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [5:0] expected_result;
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
        $dumpvars(0,a, b, clk, rst, result);
    end

endmodule
