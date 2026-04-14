`timescale 1ns/1ps

module down_counter_with_underflow_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [5:0] count;
    wire underflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter_with_underflow dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .count(count),
        .underflow(underflow)
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
        enable = 0;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();

        #1;


        check_outputs(6'd63, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Decrement (10 steps)", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat (10) @(negedge clk);
        enable = 0;
        #1;

        check_outputs(6'd53, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable/Disable Toggle", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat (5) @(negedge clk);
        enable = 0;
        repeat (5) @(negedge clk);
        #1;

        check_outputs(6'd58, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reach Zero Boundary", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat (63) @(negedge clk);
        enable = 0;
        #1;

        check_outputs(6'd0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Underflow Detection (Wrap around)", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat (64) @(negedge clk);
        enable = 0;
        #1;

        check_outputs(6'd63, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Underflow Clearance", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat (65) @(negedge clk);
        enable = 0;
        #1;

        check_outputs(6'd62, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Priority", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat (20) @(negedge clk);
        reset = 1;
        @(negedge clk);
        reset = 0;
        enable = 0;
        #1;

        check_outputs(6'd63, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Continuous Wrap-around", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat (128) @(negedge clk);
        enable = 0;

        #1;


        check_outputs(6'd63, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter_with_underflow Testbench");
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
        input [5:0] expected_count;
        input expected_underflow;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_underflow === (expected_underflow ^ underflow ^ expected_underflow)) begin
                $display("PASS");
                $display("  Outputs: count=%h, underflow=%b",
                         count, underflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, underflow=%b",
                         expected_count, expected_underflow);
                $display("  Got:      count=%h, underflow=%b",
                         count, underflow);
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
        $dumpvars(0,clk, enable, reset, count, underflow);
    end

endmodule
