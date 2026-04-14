`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALU_MODE;
    reg CIN;
    reg I0;
    reg I1;
    reg I3;
    wire COUT;
    wire SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_MODE(ALU_MODE),
        .CIN(CIN),
        .I0(I0),
        .I1(I1),
        .I3(I3),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (I0=0, I1=0, CIN=0, I3=0)", test_num);
        ALU_MODE = 4'b0000;
        I3 = 0; CIN = 0; I0 = 0; I1 = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (I0=1, I1=0, CIN=0, I3=0)", test_num);
        ALU_MODE = 4'b0000;
        I3 = 0; CIN = 0; I0 = 1; I1 = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (I0=1, I1=1, CIN=0, I3=0)", test_num);
        ALU_MODE = 4'b0000;
        I3 = 0; CIN = 0; I0 = 1; I1 = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (I0=1, I1=1, CIN=1, I3=0)", test_num);
        ALU_MODE = 4'b0000;
        I3 = 0; CIN = 1; I0 = 1; I1 = 1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (I0=1, I1=0, I3=1)", test_num);
        ALU_MODE = 4'b0000;
        I3 = 1; CIN = 0; I0 = 1; I1 = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (I0=1, I1=1, I3=1)", test_num);
        ALU_MODE = 4'b0000;
        I3 = 1; CIN = 0; I0 = 1; I1 = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (I0=0, I1=1, I3=1)", test_num);
        ALU_MODE = 4'b0000;
        I3 = 1; CIN = 0; I0 = 0; I1 = 1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND (I0=1, I1=1)", test_num);
        ALU_MODE = 4'b0010;
        I0 = 1; I1 = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND (I0=1, I1=0)", test_num);
        ALU_MODE = 4'b0010;
        I0 = 1; I1 = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise NOT (I0=0)", test_num);
        ALU_MODE = 4'b0011;
        I0 = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negation (I0=1)", test_num);
        ALU_MODE = 4'b0001;
        I0 = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Comparison >= (I0=1, I1=0)", test_num);
        ALU_MODE = 4'b0100;
        I0 = 1; I1 = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Comparison <= (I0=0, I1=1)", test_num);
        ALU_MODE = 4'b0101;
        I0 = 0; I1 = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Comparison != (I0=1, I1=0)", test_num);
        ALU_MODE = 4'b0110;
        I0 = 1; I1 = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Comparison != (I0=1, I1=1)", test_num);
        ALU_MODE = 4'b0110;
        I0 = 1; I1 = 1;
        #1;

        check_outputs(1'b0, 1'b0);
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
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input expected_COUT;
        input expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%b",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%b",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%b",
                         COUT, SUM);
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
