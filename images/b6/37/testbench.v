`timescale 1ns/1ps

module up_counter_neg_clk_tb;

    // Testbench signals (sequential circuit)
    reg clk_n;
    reg en;
    reg reset_n;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_counter_neg_clk dut (
        .clk_n(clk_n),
        .en(en),
        .reset_n(reset_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk_n = 0;
        forever #5 clk_n = ~clk_n;
    end

        task reset_dut;

    begin
        en = 0;
        reset_n = 0;
        @(negedge clk_n);
        #1;
        reset_n = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset check", test_num);
        reset_dut();
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Increment 5 times", test_num);
        reset_dut();
        en = 1;
        repeat(5) @(negedge clk_n);
        #1;
        #1;

        check_outputs(6'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Enable signal low check", test_num);
        reset_dut();
        en = 0;
        repeat(10) @(negedge clk_n);
        #1;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Pausing and resuming counter", test_num);
        reset_dut();
        en = 1;
        repeat(3) @(negedge clk_n);
        en = 0;
        repeat(5) @(negedge clk_n);
        en = 1;
        repeat(2) @(negedge clk_n);
        #1;
        #1;

        check_outputs(6'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Count to max value (63)", test_num);
        reset_dut();
        en = 1;
        repeat(63) @(negedge clk_n);
        #1;
        #1;

        check_outputs(6'd63);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Wrap around (64 cycles)", test_num);
        reset_dut();
        en = 1;
        repeat(64) @(negedge clk_n);
        #1;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Synchronous reset mid-count", test_num);
        reset_dut();
        en = 1;
        repeat(10) @(negedge clk_n);
        reset_n = 0;
        @(negedge clk_n);
        #1;
        #1;

        check_outputs(6'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_counter_neg_clk Testbench");
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
        input [5:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk_n, en, reset_n, q);
    end

endmodule
