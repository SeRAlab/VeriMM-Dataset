`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg WAIT;
    reg clk;
    reg nreset;
    wire [5:0] wait_random;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .WAIT(WAIT),
        .clk(clk),
        .nreset(nreset),
        .wait_random(wait_random)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            nreset = 0;
            WAIT = 0;
            @(posedge clk);
            #1 nreset = 1;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset and WAIT=0 check", test_num);
            reset_dut();

            WAIT = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(6'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Counter increment check (10 cycles)", test_num);
            reset_dut();
            repeat(9) @(posedge clk);

            WAIT = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(6'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: 6-bit truncation check (Counter = 64)", test_num);
            reset_dut();
            repeat(63) @(posedge clk);

            WAIT = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(6'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: WAIT deactivation check", test_num);
            reset_dut();
            WAIT = 1;
            repeat(5) @(posedge clk);
            WAIT = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(6'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Max 6-bit value check (Counter = 63)", test_num);
            reset_dut();
            repeat(62) @(posedge clk);
            WAIT = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(6'h3F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [5:0] expected_wait_random;
        begin
            if (expected_wait_random === (expected_wait_random ^ wait_random ^ expected_wait_random)) begin
                $display("PASS");
                $display("  Outputs: wait_random=%h",
                         wait_random);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wait_random=%h",
                         expected_wait_random);
                $display("  Got:      wait_random=%h",
                         wait_random);
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
        $dumpvars(0,WAIT, clk, nreset, wait_random);
    end

endmodule
