`timescale 1ns/1ps

module PP_HIGH_tb;

    // Testbench signals (combinational circuit)
    reg INA;
    reg INB;
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
    PP_HIGH dut (
        .INA(INA),
        .INB(INB),
        .ONENEG(ONENEG),
        .ONEPOS(ONEPOS),
        .TWONEG(TWONEG),
        .TWOPOS(TWOPOS),
        .PPBIT(PPBIT)
    );
    task testcase001;

    begin
        test_num = 1;
        INA = 0; INB = 0; ONEPOS = 0; ONENEG = 0; TWOPOS = 0; TWONEG = 0;
        $display("Test %0d: All inputs zero", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        INA = 1; INB = 0; ONEPOS = 1; ONENEG = 0; TWOPOS = 0; TWONEG = 0;
        $display("Test %0d: INA & ONEPOS triggered", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        INA = 0; INB = 1; ONEPOS = 0; ONENEG = 1; TWOPOS = 0; TWONEG = 0;
        $display("Test %0d: INB & ONENEG triggered", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        INA = 1; INB = 0; ONEPOS = 0; ONENEG = 0; TWOPOS = 1; TWONEG = 0;
        $display("Test %0d: INA & TWOPOS triggered", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        INA = 0; INB = 1; ONEPOS = 0; ONENEG = 0; TWOPOS = 0; TWONEG = 1;
        $display("Test %0d: INB & TWONEG triggered", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        INA = 1; INB = 1; ONEPOS = 0; ONENEG = 0; TWOPOS = 0; TWONEG = 0;
        $display("Test %0d: Inputs high but no condition triggers", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        INA = 0; INB = 0; ONEPOS = 1; ONENEG = 1; TWOPOS = 1; TWONEG = 1;
        $display("Test %0d: Condition signals high but INA/INB low", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        INA = 1; INB = 1; ONEPOS = 1; ONENEG = 1; TWOPOS = 1; TWONEG = 1;
        $display("Test %0d: All signals high", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        INA = 1; INB = 0; ONEPOS = 0; ONENEG = 1; TWOPOS = 0; TWONEG = 1;
        $display("Test %0d: INA high but only INB conditions active", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        INA = 0; INB = 1; ONEPOS = 1; ONENEG = 0; TWOPOS = 1; TWONEG = 0;
        $display("Test %0d: INB high but only INA conditions active", test_num);
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
        $display("PP_HIGH Testbench");
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
