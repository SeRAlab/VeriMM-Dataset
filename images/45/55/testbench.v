`timescale 1ns/1ps

module async_up_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    async_up_counter dut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        #2;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Count to 15", test_num);
        reset_dut();
        repeat (15) @(posedge clk);
        #1;
        #1;

        check_outputs(12'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Count to 1024 (0x400)", test_num);
        reset_dut();
        repeat (1024) @(posedge clk);
        #1;
        #1;

        check_outputs(12'h400);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Rollover Check (4096 cycles)", test_num);
        reset_dut();
        repeat (4096) @(posedge clk);
        #1;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Post-Rollover Check (5000 cycles)", test_num);
        reset_dut();
        repeat (5000) @(posedge clk);
        #1;
        #1;

        check_outputs(12'd904);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("async_up_counter Testbench");
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
        input [11:0] expected_q;
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
        $dumpvars(0,clk, rst, q);
    end

endmodule
