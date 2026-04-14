`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg INA;
    reg INB;
    reg INC;
    reg IND;
    reg ONENEG;
    reg ONEPOS;
    reg TWONEG;
    reg TWOPOS;
    wire PPBIT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .INA(INA),
        .INB(INB),
        .INC(INC),
        .IND(IND),
        .ONENEG(ONENEG),
        .ONEPOS(ONEPOS),
        .TWONEG(TWONEG),
        .TWOPOS(TWOPOS),
        .PPBIT(PPBIT)
    );
    task testcase001;

    begin
        $display("Testcase 001: All inputs LOW");
        INA = 0; INB = 0; INC = 0; IND = 0;
        ONEPOS = 0; ONENEG = 0; TWOPOS = 0; TWONEG = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: All inputs HIGH");
        INA = 1; INB = 1; INC = 1; IND = 1;
        ONEPOS = 1; ONENEG = 1; TWOPOS = 1; TWONEG = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: INA is LOW, others are HIGH");
        INA = 0; INB = 1; INC = 1; IND = 1;
        ONEPOS = 1; ONENEG = 1; TWOPOS = 1; TWONEG = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: TWOPOS is LOW, others are HIGH");
        INA = 1; INB = 1; INC = 1; IND = 1;
        ONEPOS = 1; ONENEG = 1; TWOPOS = 0; TWONEG = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: INB is LOW, others are HIGH");
        INA = 1; INB = 0; INC = 1; IND = 1;
        ONEPOS = 1; ONENEG = 1; TWOPOS = 1; TWONEG = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: TWONEG is LOW, others are HIGH");
        INA = 1; INB = 1; INC = 1; IND = 1;
        ONEPOS = 1; ONENEG = 1; TWOPOS = 1; TWONEG = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: INC is LOW, others are HIGH");
        INA = 1; INB = 1; INC = 0; IND = 1;
        ONEPOS = 1; ONENEG = 1; TWOPOS = 1; TWONEG = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: ONEPOS is LOW, others are HIGH");
        INA = 1; INB = 1; INC = 1; IND = 1;
        ONEPOS = 0; ONENEG = 1; TWOPOS = 1; TWONEG = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: IND is LOW, others are HIGH");
        INA = 1; INB = 1; INC = 1; IND = 0;
        ONEPOS = 1; ONENEG = 1; TWOPOS = 1; TWONEG = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: ONENEG is LOW, others are HIGH");
        INA = 1; INB = 1; INC = 1; IND = 1;
        ONEPOS = 1; ONENEG = 0; TWOPOS = 1; TWONEG = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        $display("Testcase 011: Random pattern (multiple LOWs)");
        INA = 1; INB = 0; INC = 1; IND = 0;
        ONEPOS = 1; ONENEG = 0; TWOPOS = 1; TWONEG = 1;
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input expected_PPBIT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PPBIT === (expected_PPBIT ^ PPBIT ^ expected_PPBIT)) begin
                $display("PASS");
                $display("  Outputs: PPBIT=%b",
                         PPBIT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PPBIT=%b",
                         expected_PPBIT);
                $display("  Got:      PPBIT=%b",
                         PPBIT);
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

endmodule
