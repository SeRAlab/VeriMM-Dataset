`timescale 1ns/1ps

module carrier_frequency_recovery_tb;

    // Testbench signals (sequential circuit)
    reg baseband_signal;
    reg clk;
    reg local_oscillator;
    wire recovered_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carrier_frequency_recovery dut (
        .baseband_signal(baseband_signal),
        .clk(clk),
        .local_oscillator(local_oscillator),
        .recovered_signal(recovered_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            baseband_signal = 0;
            local_oscillator = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Baseband=0, LO=0");
            reset_dut();
            baseband_signal = 0;
            local_oscillator = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Baseband=1, LO=1");
            reset_dut();
            baseband_signal = 1;
            local_oscillator = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Baseband=1, LO=0");
            reset_dut();
            baseband_signal = 1;
            local_oscillator = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Baseband=0, LO=1");
            reset_dut();
            baseband_signal = 0;
            local_oscillator = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Toggling local oscillator");
            reset_dut();
            baseband_signal = 1;
            local_oscillator = 0;
            @(posedge clk);
            #1;
            local_oscillator = 1;
            repeat(2) @(posedge clk);
            #1 #1;
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
        $display("carrier_frequency_recovery Testbench");
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
        input expected_recovered_signal;
        begin
            if (expected_recovered_signal === (expected_recovered_signal ^ recovered_signal ^ expected_recovered_signal)) begin
                $display("PASS");
                $display("  Outputs: recovered_signal=%b",
                         recovered_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: recovered_signal=%b",
                         expected_recovered_signal);
                $display("  Got:      recovered_signal=%b",
                         recovered_signal);
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
        $dumpvars(0,baseband_signal, clk, local_oscillator, recovered_signal);
    end

endmodule
