`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg resetn;
    wire [10:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .clk(clk),
        .resetn(resetn),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            resetn = 0;
            @(negedge clk);
            resetn = 1;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset check");
            reset_dut();
            #1;

            check_outputs(11'd2047);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Single decrement (2047 -> 2046)");
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(11'd2046);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: 100 decrements (2047 - 100 = 1947)");
            reset_dut();
            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(11'd1947);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Count down to zero (2047 cycles)");
            reset_dut();
            repeat(2047) @(posedge clk);
            #1;
            #1;

            check_outputs(11'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Verify rollover (2048 cycles)");
            reset_dut();
            repeat(2048) @(posedge clk);
            #1;
            #1;

            check_outputs(11'd2047);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Synchronous reset mid-count");
            reset_dut();
            repeat(50) @(posedge clk);
            @(negedge clk);
            resetn = 0;
            @(posedge clk);
            #1;
            resetn = 1;
            #1;

            check_outputs(11'd2047);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Wrap-around and continue (2049 cycles)");
            reset_dut();
            repeat(2049) @(posedge clk);
            #1;
            #1;

            check_outputs(11'd2046);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
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
        input [10:0] expected_count;
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
        $dumpvars(0,clk, resetn, count);
    end

endmodule
