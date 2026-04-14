`timescale 1ns/1ps

module binary_counter_with_pause_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pause;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_with_pause dut (
        .clk(clk),
        .pause(pause),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        pause = 0;
        @(posedge clk);
        #1;
        rst_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %03d: Basic Counting", test_num);
        reset_dut();
        repeat(7) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %03d: Pause Functionality", test_num);
        reset_dut();
        repeat(3) @(posedge clk);
        pause = 1;
        repeat(5) @(posedge clk);
        pause = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %03d: Roll-over (16 Cycles)", test_num);
        reset_dut();
        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %03d: Continuous Pause from Start", test_num);
        reset_dut();
        pause = 1;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %03d: Pause at Roll-over Point", test_num);
        reset_dut();
        repeat(15) @(posedge clk);
        pause = 1;
        repeat(3) @(posedge clk);
        pause = 0;
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_with_pause Testbench");
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, pause, q);
    end

endmodule
