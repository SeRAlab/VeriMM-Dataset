`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] load_value;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .enable(enable),
        .load_value(load_value),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        @(negedge clk);
        reset = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic countdown from 5 to 0", test_num);
        load_value = 4'd5;
        reset_dut();
        enable = 1;

        repeat(5) @(negedge clk);
        enable = 0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hold at zero after reaching it", test_num);
        load_value = 4'd2;
        reset_dut();
        enable = 1;

        repeat(4) @(negedge clk);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable gating (pause and resume)", test_num);
        load_value = 4'd10;
        reset_dut();
        enable = 1;
        repeat(3) @(negedge clk);
        enable = 0;
        repeat(2) @(negedge clk);
        enable = 1;
        repeat(2) @(negedge clk);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Countdown from maximum value (15)", test_num);
        load_value = 4'd15;
        reset_dut();
        enable = 1;
        repeat(10) @(negedge clk);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset behavior during countdown", test_num);
        load_value = 4'd8;
        reset_dut();
        enable = 1;
        repeat(4) @(negedge clk);

        load_value = 4'd12;
        reset = 1;
        @(negedge clk);
        reset = 0;
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Starting at zero", test_num);
        load_value = 4'd0;
        reset_dut();
        enable = 1;
        repeat(2) @(negedge clk);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rapid enable toggling", test_num);
        load_value = 4'd4;
        reset_dut();
        enable = 1; @(negedge clk);
        enable = 0; @(negedge clk);
        enable = 1; @(negedge clk);
        enable = 0; @(negedge clk);
        enable = 1; @(negedge clk);
        #1;

        check_outputs(4'd1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter Testbench");
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
        input [3:0] expected_count;
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
        $dumpvars(0,clk, enable, load_value, reset, count);
    end

endmodule
