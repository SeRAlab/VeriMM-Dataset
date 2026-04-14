`timescale 1ns/1ps

module conveyor_belt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg resetn;
    reg start;
    reg stop;
    wire running;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    conveyor_belt dut (
        .clk(clk),
        .resetn(resetn),
        .start(start),
        .stop(stop),
        .running(running)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        resetn = 0;
        start = 0;
        stop = 0;
        @(posedge clk);
        #1 resetn = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Initial State after Reset", test_num);
        reset_dut();

        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Start pulse", test_num);
        reset_dut();
        start = 1;
        @(posedge clk);
        #1 start = 0;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Start then Stop pulse", test_num);
        reset_dut();

        start = 1;
        @(posedge clk);
        #1 start = 0;
        @(posedge clk);

        stop = 1;
        @(posedge clk);
        #1 stop = 0;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: State persistence while running", test_num);
        reset_dut();
        start = 1;
        @(posedge clk);
        #1 start = 0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Simultaneous start and stop", test_num);
        reset_dut();
        start = 1;
        stop = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Stop interrupt", test_num);
        reset_dut();
        start = 1;
        @(posedge clk);
        #1 stop = 1;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Start-Stop-Start sequence", test_num);
        reset_dut();

        start = 1; @(posedge clk); #1 start = 0;

        stop = 1;  @(posedge clk); #1 stop = 0;

        start = 1; @(posedge clk); #1 start = 0;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("conveyor_belt Testbench");
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
        input expected_running;
        begin
            if (expected_running === (expected_running ^ running ^ expected_running)) begin
                $display("PASS");
                $display("  Outputs: running=%b",
                         running);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: running=%b",
                         expected_running);
                $display("  Got:      running=%b",
                         running);
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
        $dumpvars(0,clk, resetn, start, stop, running);
    end

endmodule
