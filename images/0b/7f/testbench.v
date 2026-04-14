`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire timer_expired;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .reset(reset),
        .timer_expired(timer_expired)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Testing Watchdog Expiration", test_num);
        reset_dut();

        repeat(100) @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Testing Watchdog Refresh (Petting)", test_num);
        reset_dut();

        repeat(10) begin
            repeat(5) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Testing Recovery After Expiration", test_num);
        reset_dut();

        repeat(100) @(posedge clk);

        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Testing Late Refresh", test_num);
        reset_dut();

        repeat(15) @(posedge clk);
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;

        repeat(5) @(posedge clk);

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
        $display("watchdog_timer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_timer_expired;
        begin
            if (expected_timer_expired === (expected_timer_expired ^ timer_expired ^ expected_timer_expired)) begin
                $display("PASS");
                $display("  Outputs: timer_expired=%b",
                         timer_expired);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timer_expired=%b",
                         expected_timer_expired);
                $display("  Got:      timer_expired=%b",
                         timer_expired);
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
        $dumpvars(0,clk, reset, timer_expired);
    end

endmodule
