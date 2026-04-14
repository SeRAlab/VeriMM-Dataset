`timescale 1ns/1ps

module UpDownCounter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg up_down;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    UpDownCounter dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        reset = 1;
        enable = 0;
        up_down = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset verification", test_num);
        reset_dut();
        @(negedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Count up for 10 cycles", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        up_down = 1;
        repeat (10) @(posedge clk);
        #1;
        #1;

        check_outputs(16'h000A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Count down from zero (Underflow)", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        up_down = 0;
        repeat (1) @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Enable signal toggle test", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        up_down = 1;
        repeat (5) @(posedge clk);
        enable = 0;
        repeat (5) @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0005);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Direction switching (Up then Down)", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        up_down = 1;
        repeat (15) @(posedge clk);
        up_down = 0;
        repeat (5) @(posedge clk);
        #1;
        #1;

        check_outputs(16'h000A);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Synchronous reset priority", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        up_down = 1;
        repeat (5) @(posedge clk);
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Count down multiple cycles", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        up_down = 0;
        repeat (255) @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFF01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("UpDownCounter Testbench");
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
        input [15:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, enable, reset, up_down, count);
    end

endmodule
