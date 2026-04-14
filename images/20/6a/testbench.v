`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg start;
    reg stop;
    wire busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .start(start),
        .stop(stop),
        .busy(busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        start = 0;
        stop = 0;


        @(posedge clk);
        #1 stop = 1;
        @(posedge clk);
        #1 stop = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Assert start, check if busy", test_num);
        reset_dut();

        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;


        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Assert start then stop, check if ready", test_num);
        reset_dut();


        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;


        repeat(3) @(posedge clk);


        #1 stop = 1;
        @(posedge clk);
        #1 stop = 0;

        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Idle persistence test", test_num);
        reset_dut();

        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Busy persistence test (long wait)", test_num);
        reset_dut();

        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;


        repeat(50) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Multiple start pulses while busy", test_num);
        reset_dut();

        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        repeat(5) @(posedge clk);

        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Simultaneous start and stop", test_num);
        reset_dut();

        @(posedge clk);
        #1 start = 1;
        stop = 1;
        @(posedge clk);
        #1 start = 0;
        stop = 0;

        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_busy;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy)) begin
                $display("PASS");
                $display("  Outputs: busy=%b",
                         busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b",
                         expected_busy);
                $display("  Got:      busy=%b",
                         busy);
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
        $dumpvars(0,clk, start, stop, busy);
    end

endmodule
