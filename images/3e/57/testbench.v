`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg DATA;
    reg PRECHARGE;
    reg WRITE_ENABLE;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .DATA(DATA),
        .PRECHARGE(PRECHARGE),
        .WRITE_ENABLE(WRITE_ENABLE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        PRECHARGE = 0;
        forever #5 PRECHARGE = ~PRECHARGE;
    end

        task reset_dut;

    begin
        @(posedge PRECHARGE);
        @(negedge PRECHARGE);
        DATA = 0;
        WRITE_ENABLE = 0;
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Write 1");
        reset_dut();
        DATA = 1;
        WRITE_ENABLE = 1;
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Write 0");
        reset_dut();
        DATA = 0;
        WRITE_ENABLE = 1;
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Data Retention (WE=0)");
        reset_dut();

        DATA = 1;
        WRITE_ENABLE = 1;
        #1;

        WRITE_ENABLE = 0;
        DATA = 0;
        #2;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Write Inhibit");
        reset_dut();
        DATA = 1;
        WRITE_ENABLE = 0;
        #2;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Precharge Priority Over Write");
        reset_dut();

        @(posedge PRECHARGE);
        DATA = 1;
        WRITE_ENABLE = 1;
        #2;

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
        $display("dram_cell Testbench");
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
        $dumpvars(0,DATA, PRECHARGE, WRITE_ENABLE, Q);
    end

endmodule
