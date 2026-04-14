`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg SPI_clock;
    reg clock;
    wire SPI_clock_synced;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SPI_clock(SPI_clock),
        .clock(clock),
        .SPI_clock_synced(SPI_clock_synced)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            SPI_clock = 0;

            repeat (3) @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            SPI_clock = 0;
            repeat (2) @(posedge clock);
            #1;
            $display("Testcase %0d: Steady Low Input", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clock);
            SPI_clock = 1;
            repeat (2) @(posedge clock);
            #1;
            $display("Testcase %0d: Transition to High", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(negedge clock);
            SPI_clock = 1;
            repeat (2) @(posedge clock);

            @(negedge clock);
            SPI_clock = 0;
            repeat (2) @(posedge clock);
            #1;
            $display("Testcase %0d: Transition to Low", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clock);
            SPI_clock = 1;
            @(posedge clock);
            #1;
            $display("Testcase %0d: Latency check (Output should still be 0 after 1 cycle)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clock);
            SPI_clock = 1;
            #2;
            SPI_clock = 0;
            #2;
            SPI_clock = 1;
            repeat (3) @(posedge clock);
            #1;
            $display("Testcase %0d: Final state after rapid transitions", test_num);
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
        input expected_SPI_clock_synced;
        begin
            if (expected_SPI_clock_synced === (expected_SPI_clock_synced ^ SPI_clock_synced ^ expected_SPI_clock_synced)) begin
                $display("PASS");
                $display("  Outputs: SPI_clock_synced=%b",
                         SPI_clock_synced);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SPI_clock_synced=%b",
                         expected_SPI_clock_synced);
                $display("  Got:      SPI_clock_synced=%b",
                         SPI_clock_synced);
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
        $dumpvars(0,SPI_clock, clock, SPI_clock_synced);
    end

endmodule
