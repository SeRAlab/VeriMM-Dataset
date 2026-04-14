`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg reset;
    reg start;
    wire [511:0] message;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .start(start),
        .message(message)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            a = 0;
            b = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(512'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Shift Operation", test_num);
            reset_dut();
            @(posedge clk);
            a = 32'hAAAA_AAAA;
            b = 32'hBBBB_BBBB;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            #1;

            check_outputs({448'b0, 32'hAAAA_AAAA, 32'hBBBB_BBBB});
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Start Signal Gating (No shift when start=0)", test_num);
            reset_dut();
            @(posedge clk);
            a = 32'hFFFF_FFFF;
            b = 32'hEEEE_EEEE;
            start = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(512'b0);
        end
        endtask

    task testcase004;

        reg [511:0] expected;
        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Fill Buffer (8 consecutive shifts)", test_num);
            reset_dut();
            expected = 0;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                a = i[31:0];
                b = ~i[31:0];
                start = 1;
                expected = {expected[447:0], a, b};
            end
            @(posedge clk);
            #1 start = 0;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase005;

        reg [511:0] expected;
        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Buffer Overflow (Shifting out oldest data)", test_num);
            reset_dut();

            for (i = 1; i <= 9; i = i + 1) begin
                @(posedge clk);
                a = i[31:0];
                b = i[31:0];
                start = 1;
            end
            @(posedge clk);
            #1 start = 0;

            expected = {
                32'h2, 32'h2, 32'h3, 32'h3, 32'h4, 32'h4, 32'h5, 32'h5,
                32'h6, 32'h6, 32'h7, 32'h7, 32'h8, 32'h8, 32'h9, 32'h9
            };
            #1;

            check_outputs(expected);
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
        input [511:0] expected_message;
        begin
            if (expected_message === (expected_message ^ message ^ expected_message)) begin
                $display("PASS");
                $display("  Outputs: message=%h",
                         message);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: message=%h",
                         expected_message);
                $display("  Got:      message=%h",
                         message);
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
        $dumpvars(0,a, b, clk, reset, start, message);
    end

endmodule
