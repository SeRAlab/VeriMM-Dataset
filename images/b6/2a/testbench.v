`timescale 1ns/1ps

module d_flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg d;
    reg reset;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_flip_flop dut (
        .clock(clock),
        .d(d),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 0;
            @(negedge clock);
            reset = 0;
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Write 1 and check if q follows d on rising edge.");
            reset_dut();
            d = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Write 0 and check if q follows d on rising edge.");
            reset_dut();
            d = 1;
            @(posedge clock);
            d = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Verify asynchronous reset overrides clock and data.");
            reset_dut();
            d = 1;
            @(posedge clock);
            #2;
            reset = 1;
            #1;
            #1;

            check_outputs(0);
            reset = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Verify q does not change when clock is stable (level-sensitive check).");
            reset_dut();
            d = 1;
            @(posedge clock);
            #2;
            d = 0;
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Verify reset works while clock is high.");
            reset_dut();
            d = 1;
            @(posedge clock);
            #2;
            reset = 1;
            #1;
            #1;

            check_outputs(0);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Toggle d over multiple clock cycles.");
            reset_dut();
            d = 1; @(posedge clock);
            d = 0; @(posedge clock);
            d = 1; @(posedge clock);
            d = 1; @(posedge clock);
            d = 0; @(posedge clock);
            #2;
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
        $display("d_flip_flop Testbench");
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
        $dumpvars(0,clock, d, reset, q);
    end

endmodule
