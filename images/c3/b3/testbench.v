`timescale 1ns/1ps

module clock_control_altclkctrl_0_tb;

    // Testbench signals (sequential circuit)
    reg ena;
    reg inclk;
    wire outclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_control_altclkctrl_0 dut (
        .ena(ena),
        .inclk(inclk),
        .outclk(outclk)
    );

    // Clock generation (10ns period)
    initial begin
        ena = 0;
        forever #5 ena = ~ena;
    end

        task reset_dut;

        begin
            ena = 0;
            inclk = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            ena = 0;
            inclk = 0;
            #10;
            inclk = 1;
            #5;
            $display("Testcase 001: Checking gating (ena=0)...");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            ena = 1;
            #10;
            inclk = 1;
            #5;
            $display("Testcase 002: Checking first pulse (ena=1)...");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            ena = 1;
            #10;

            inclk = 1; #10;
            inclk = 0; #10;

            inclk = 1;
            #5;
            $display("Testcase 003: Checking half-frequency (skipping second pulse)...");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            ena = 1;
            #10;
            inclk = 1; #10;
            inclk = 0; #10;
            inclk = 1; #10;
            inclk = 0; #10;
            inclk = 1;
            #5;
            $display("Testcase 004: Checking periodicity (third pulse passing)...");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            ena = 1;
            #10;
            inclk = 1; #10;
            inclk = 0; #5;
            $display("Testcase 005: Checking outclk follows inclk low...");
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
        $display("clock_control_altclkctrl_0 Testbench");
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
        input expected_outclk;
        begin
            if (expected_outclk === (expected_outclk ^ outclk ^ expected_outclk)) begin
                $display("PASS");
                $display("  Outputs: outclk=%b",
                         outclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outclk=%b",
                         expected_outclk);
                $display("  Got:      outclk=%b",
                         outclk);
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
        $dumpvars(0,ena, inclk, outclk);
    end

endmodule
