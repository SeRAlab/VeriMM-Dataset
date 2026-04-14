`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_signal;
    reg [3:0] timeout_period;
    wire timeout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .reset_signal(reset_signal),
        .timeout_period(timeout_period),
        .timeout(timeout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_signal = 1;
            timeout_period = 4'd5;
            @(posedge clk);
            #1;
            reset_signal = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify timeout triggers after inactivity", test_num);
            reset_dut();

            timeout_period = 4'd4;

            repeat (5) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify reset signal prevents timeout", test_num);
            reset_dut();

            timeout_period = 4'd8;


            repeat (4) @(posedge clk);

            reset_signal = 1;
            @(posedge clk);
            #1 reset_signal = 0;


            repeat (4) @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify reset clears timeout signal", test_num);
            reset_dut();

            timeout_period = 4'd3;

            repeat (4) @(posedge clk);


            reset_signal = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
            reset_signal = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify functionality with maximum timeout period (15)", test_num);
            reset_dut();

            timeout_period = 4'd15;


            repeat (14) @(posedge clk);
            #1;
            if (timeout !== 1'b0) $display("  Intermediate check failed at cycle 14");


            repeat (2) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify functionality with minimum timeout period (1)", test_num);
            reset_dut();

            timeout_period = 4'd1;


            repeat (2) @(posedge clk);
            #2;

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
        input expected_timeout;
        begin
            if (expected_timeout === (expected_timeout ^ timeout ^ expected_timeout)) begin
                $display("PASS");
                $display("  Outputs: timeout=%b",
                         timeout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timeout=%b",
                         expected_timeout);
                $display("  Got:      timeout=%b",
                         timeout);
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
        $dumpvars(0,clk, reset_signal, timeout_period, timeout);
    end

endmodule
