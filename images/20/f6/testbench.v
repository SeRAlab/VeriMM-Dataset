`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg RESET;
    reg SELECT;
    reg WE;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .D(D),
        .RESET(RESET),
        .SELECT(SELECT),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        RESET = 0;
        forever #5 RESET = ~RESET;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;

            wait(RESET == 1);
            D = 0; WE = 0; SELECT = 0;

            wait(RESET == 0);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write 1");
            reset_dut();
            WE = 1; SELECT = 1; D = 1;
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Write 0");
            reset_dut();

            WE = 1; SELECT = 1; D = 1;
            #2;
            D = 0;
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: WE Inhibition");
            reset_dut();
            WE = 0; SELECT = 1; D = 1;
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: SELECT Inhibition");
            reset_dut();
            WE = 1; SELECT = 0; D = 1;
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Data Retention");
            reset_dut();

            WE = 1; SELECT = 1; D = 1;
            #2;

            WE = 0; SELECT = 1; D = 0;
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: RESET Priority");
            reset_dut();

            WE = 1; SELECT = 1; D = 1;
            wait(RESET == 1);
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
        $display("sram_cell Testbench");
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,D, RESET, SELECT, WE, Q);
    end

endmodule
