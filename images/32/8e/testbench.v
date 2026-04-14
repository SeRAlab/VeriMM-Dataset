`timescale 1ns/1ps

module frequency_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire divided_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    frequency_divider dut (
        .clk(clk),
        .reset(reset),
        .divided_clk(divided_clk)
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
            $display("Testcase 001: Checking initial state after reset...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking state after 2 cycles (should not have toggled)...");
            test_num = 2;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking toggle after 4 cycles...");
            test_num = 3;
            reset_dut();
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking state after 6 cycles (should still be high)...");
            test_num = 4;
            reset_dut();
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking second toggle after 8 cycles...");
            test_num = 5;
            reset_dut();
            repeat(8) @(posedge clk);
            #1;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Checking third toggle after 12 cycles...");
            test_num = 6;
            reset_dut();
            repeat(12) @(posedge clk);
            #1;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Checking fourth toggle after 16 cycles...");
            test_num = 7;
            reset_dut();
            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("frequency_divider Testbench");
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
        input expected_divided_clk;
        begin
            if (expected_divided_clk === (expected_divided_clk ^ divided_clk ^ expected_divided_clk)) begin
                $display("PASS");
                $display("  Outputs: divided_clk=%b",
                         divided_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: divided_clk=%b",
                         expected_divided_clk);
                $display("  Got:      divided_clk=%b",
                         divided_clk);
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
        $dumpvars(0,clk, reset, divided_clk);
    end

endmodule
