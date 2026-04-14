`timescale 1ns/1ps

module PP_MIDDLE_tb;

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
    PP_MIDDLE dut (
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
        test_num = 1;
        $display("Testcase %0d: All inputs zero", test_num);
        INA = 0; INB = 0; INC = 0; IND = 0;
        ONEPOS = 0; ONENEG = 0; TWOPOS = 0; TWONEG = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: INA and TWOPOS active", test_num);
        INA = 1; INB = 0; INC = 0; IND = 0;
        ONEPOS = 0; ONENEG = 0; TWOPOS = 1; TWONEG = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: INB and TWONEG active", test_num);
        INA = 0; INB = 1; INC = 0; IND = 0;
        ONEPOS = 0; ONENEG = 0; TWOPOS = 0; TWONEG = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: INC and ONEPOS active", test_num);
        INA = 0; INB = 0; INC = 1; IND = 0;
        ONEPOS = 1; ONENEG = 0; TWOPOS = 0; TWONEG = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: IND and ONENEG active", test_num);
        INA = 0; INB = 0; INC = 0; IND = 1;
        ONEPOS = 0; ONENEG = 1; TWOPOS = 0; TWONEG = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: All data high, all control low", test_num);
        INA = 1; INB = 1; INC = 1; IND = 1;
        ONEPOS = 0; ONENEG = 0; TWOPOS = 0; TWONEG = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: All control high, all data low", test_num);
        INA = 0; INB = 0; INC = 0; IND = 0;
        ONEPOS = 1; ONENEG = 1; TWOPOS = 1; TWONEG = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Mismatched signals (INA high, but ONENEG high)", test_num);
        INA = 1; INB = 0; INC = 0; IND = 0;
        ONEPOS = 0; ONENEG = 1; TWOPOS = 0; TWONEG = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Multiple active matches (INA/TWOPOS and INC/ONEPOS)", test_num);
        INA = 1; INB = 0; INC = 1; IND = 0;
        ONEPOS = 1; ONENEG = 0; TWOPOS = 1; TWONEG = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: All inputs high", test_num);
        INA = 1; INB = 1; INC = 1; IND = 1;
        ONEPOS = 1; ONENEG = 1; TWOPOS = 1; TWONEG = 1;
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
        $display("PP_MIDDLE Testbench");
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
