`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DataA0;
    reg DataA1;
    reg DataA2;
    reg DataA3;
    reg DataB0;
    reg DataB1;
    reg DataB2;
    reg DataB3;
    wire Cout;
    wire Result0;
    wire Result1;
    wire Result2;
    wire Result3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DataA0(DataA0),
        .DataA1(DataA1),
        .DataA2(DataA2),
        .DataA3(DataA3),
        .DataB0(DataB0),
        .DataB1(DataB1),
        .DataB2(DataB2),
        .DataB3(DataB3),
        .Cout(Cout),
        .Result0(Result0),
        .Result1(Result1),
        .Result2(Result2),
        .Result3(Result3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: DataA=0 (0000), DataB=0 (0000) -> Result=0 (0000), Cout=0", test_num);
            DataA3=0; DataA2=0; DataA1=0; DataA0=0;
            DataB3=0; DataB2=0; DataB1=0; DataB0=0;
            #1;

            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: DataA=1 (0001), DataB=2 (0010) -> Result=3 (0011), Cout=0", test_num);
            DataA3=0; DataA2=0; DataA1=0; DataA0=1;
            DataB3=0; DataB2=0; DataB1=1; DataB0=0;
            #1;

            check_outputs(0, 1, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: DataA=5 (0101), DataB=10 (1010) -> Result=15 (1111), Cout=0", test_num);
            DataA3=0; DataA2=1; DataA1=0; DataA0=1;
            DataB3=1; DataB2=0; DataB1=1; DataB0=0;
            #1;

            check_outputs(0, 1, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: DataA=8 (1000), DataB=8 (1000) -> Result=0 (0000), Cout=1", test_num);
            DataA3=1; DataA2=0; DataA1=0; DataA0=0;
            DataB3=1; DataB2=0; DataB1=0; DataB0=0;
            #1;

            check_outputs(1, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: DataA=15 (1111), DataB=1 (0001) -> Result=0 (0000), Cout=1", test_num);
            DataA3=1; DataA2=1; DataA1=1; DataA0=1;
            DataB3=0; DataB2=0; DataB1=0; DataB0=1;
            #1;

            check_outputs(1, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: DataA=15 (1111), DataB=15 (1111) -> Result=14 (1110), Cout=1", test_num);
            DataA3=1; DataA2=1; DataA1=1; DataA0=1;
            DataB3=1; DataB2=1; DataB1=1; DataB0=1;
            #1;

            check_outputs(1, 0, 1, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: DataA=7 (0111), DataB=1 (0001) -> Result=8 (1000), Cout=0", test_num);
            DataA3=0; DataA2=1; DataA1=1; DataA0=1;
            DataB3=0; DataB2=0; DataB1=0; DataB0=1;
            #1;

            check_outputs(0, 0, 0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: DataA=12 (1100), DataB=6 (0110) -> Result=2 (0010), Cout=1", test_num);
            DataA3=1; DataA2=1; DataA1=0; DataA0=0;
            DataB3=0; DataB2=1; DataB1=1; DataB0=0;
            #1;

            check_outputs(1, 0, 1, 0, 0);
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
        input expected_Cout;
        input expected_Result0;
        input expected_Result1;
        input expected_Result2;
        input expected_Result3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Result0 === (expected_Result0 ^ Result0 ^ expected_Result0) &&
                expected_Result1 === (expected_Result1 ^ Result1 ^ expected_Result1) &&
                expected_Result2 === (expected_Result2 ^ Result2 ^ expected_Result2) &&
                expected_Result3 === (expected_Result3 ^ Result3 ^ expected_Result3)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Result0=%b, Result1=%b, Result2=%b, Result3=%b",
                         Cout, Result0, Result1, Result2, Result3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Result0=%b, Result1=%b, Result2=%b, Result3=%b",
                         expected_Cout, expected_Result0, expected_Result1, expected_Result2, expected_Result3);
                $display("  Got:      Cout=%b, Result0=%b, Result1=%b, Result2=%b, Result3=%b",
                         Cout, Result0, Result1, Result2, Result3);
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
