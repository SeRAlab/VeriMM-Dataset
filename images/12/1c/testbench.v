`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] matrix;
    wire [3:0] L;
    wire [3:0] U;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_Decomposition dut (
        .matrix(matrix),
        .L(L),
        .U(U)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Identity Matrix (A=1, B=0, C=0, D=1)", test_num);
        matrix = 4'b0000;
        #5;
        matrix = 4'b1001;

        #1;


        check_outputs(4'b1001, 4'b1001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Ones Matrix (A=1, B=1, C=1, D=1)", test_num);
        matrix = 4'b0000;
        #5;
        matrix = 4'b1111;


        #1;



        check_outputs(4'b1011, 4'b1100);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Pivot Handling (A=0, B=1, C=1, D=1)", test_num);
        matrix = 4'b0000;
        #5;
        matrix = 4'b0111;


        #1;



        check_outputs(4'b1001, 4'b0101);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Underflow/Modular Subtraction (A=1, B=1, C=1, D=0)", test_num);
        matrix = 4'b0000;
        #5;
        matrix = 4'b1110;


        #1;



        check_outputs(4'b1011, 4'b1101);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero C and D (A=1, B=1, C=0, D=0)", test_num);
        matrix = 4'b0000;
        #5;
        matrix = 4'b1100;


        #1;



        check_outputs(4'b1001, 4'b1100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros Matrix", test_num);
        matrix = 4'b0000;
        #5;
        matrix = 4'b0000;


        #1;



        check_outputs(4'b1001, 4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Only D bit set (A=0, B=0, C=0, D=1)", test_num);
        matrix = 4'b0000;
        #5;
        matrix = 4'b0001;


        #1;



        check_outputs(4'b1001, 4'b0001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Matrix with A=1, B=0, C=1, D=1", test_num);
        matrix = 4'b0000;
        #5;
        matrix = 4'b1011;


        #1;



        check_outputs(4'b1011, 4'b1001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LU_Decomposition Testbench");
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
        input [3:0] expected_L;
        input [3:0] expected_U;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_L === (expected_L ^ L ^ expected_L) &&
                expected_U === (expected_U ^ U ^ expected_U)) begin
                $display("PASS");
                $display("  Outputs: L=%h, U=%h",
                         L, U);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L=%h, U=%h",
                         expected_L, expected_U);
                $display("  Got:      L=%h, U=%h",
                         L, U);
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
