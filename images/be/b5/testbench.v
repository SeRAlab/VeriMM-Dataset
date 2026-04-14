`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data1;
    reg [31:0] data2;
    reg [1:0] operation;
    wire NaN_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data1(data1),
        .data2(data2),
        .operation(operation),
        .NaN_flag(NaN_flag)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Op 00 - Inf and -Inf (Invalid Addition/Subtraction)", test_num);
        operation = 2'b00;
        data1 = P_INF;
        data2 = N_INF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Op 00 - Normal Addition", test_num);
        operation = 2'b00;
        data1 = NORMAL;
        data2 = NORMAL;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Op 01 - Zero * Infinity", test_num);
        operation = 2'b01;
        data1 = P_ZERO;
        data2 = P_INF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Op 01 - Infinity * Zero", test_num);
        operation = 2'b01;
        data1 = N_INF;
        data2 = N_ZERO;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Op 01 - Normal Multiplication", test_num);
        operation = 2'b01;
        data1 = NORMAL;
        data2 = P_INF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Op 10 - Zero / Zero", test_num);
        operation = 2'b10;
        data1 = P_ZERO;
        data2 = N_ZERO;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Op 10 - Inf / Inf", test_num);
        operation = 2'b10;
        data1 = P_INF;
        data2 = N_INF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Op 10 - Normal Division by Zero (Result is Inf, not NaN)", test_num);
        operation = 2'b10;
        data1 = NORMAL;
        data2 = P_ZERO;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input is already NaN (Data1)", test_num);
        operation = 2'b00;
        data1 = Q_NAN;
        data2 = NORMAL;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input is already NaN (Data2)", test_num);
        operation = 2'b10;
        data1 = NORMAL;
        data2 = Q_NAN;
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
        input expected_NaN_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_NaN_flag === (expected_NaN_flag ^ NaN_flag ^ expected_NaN_flag)) begin
                $display("PASS");
                $display("  Outputs: NaN_flag=%b",
                         NaN_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: NaN_flag=%b",
                         expected_NaN_flag);
                $display("  Got:      NaN_flag=%b",
                         NaN_flag);
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
