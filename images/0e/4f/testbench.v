`timescale 1ns/1ps

module PLL_4x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PLL_4x dut (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            reset = 1;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Verifying high phase of 1st sub-cycle...");
            reset_dut();
            @(posedge clk_in);
            #0.625;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Verifying low phase of 1st sub-cycle...");
            reset_dut();
            @(posedge clk_in);
            #1.875;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verifying high phase of 2nd sub-cycle...");
            reset_dut();
            @(posedge clk_in);
            #3.125;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verifying high phase of 3rd sub-cycle...");
            reset_dut();
            @(posedge clk_in);
            #5.625;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verifying low phase of 4th sub-cycle...");
            reset_dut();
            @(posedge clk_in);
            #9.375;
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
        $display("PLL_4x Testbench");
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_in, reset, clk_out);
    end

endmodule
