`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] timeout;
    reg update;
    wire reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .timeout(timeout),
        .update(update),
        .reset(reset)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            update <= 1;
            timeout <= 4'd5;
            @(posedge clk);
            update <= 0;

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing timeout expiration", test_num);
            reset_dut();
            timeout <= 4'd5;


            repeat(6) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing update before expiration", test_num);
            reset_dut();
            timeout <= 4'd8;


            @(posedge clk);
            update <= 1;
            @(posedge clk);
            update <= 0;


            repeat(4) @(posedge clk);


            update <= 1;
            @(posedge clk);
            update <= 0;


            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing expiration after an update", test_num);
            reset_dut();
            timeout <= 4'd3;


            @(posedge clk);
            update <= 1;
            @(posedge clk);
            update <= 0;


            repeat(2) @(posedge clk);


            update <= 1;
            @(posedge clk);
            update <= 0;


            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing minimum timeout (1)", test_num);
            reset_dut();
            timeout <= 4'd1;


            @(posedge clk);
            update <= 1;
            @(posedge clk);
            update <= 0;


            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing maximum timeout (15)", test_num);
            reset_dut();
            timeout <= 4'd15;


            @(posedge clk);
            update <= 1;
            @(posedge clk);
            update <= 0;


            repeat(14) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);


            repeat(2) @(posedge clk);
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
        input expected_reset;
        begin
            if (expected_reset === (expected_reset ^ reset ^ expected_reset)) begin
                $display("PASS");
                $display("  Outputs: reset=%b",
                         reset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reset=%b",
                         expected_reset);
                $display("  Got:      reset=%b",
                         reset);
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
        $dumpvars(0,clk, timeout, update, reset);
    end

endmodule
