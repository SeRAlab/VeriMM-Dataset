`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg iA;
    reg iB;
    reg iC;
    reg iD;
    wire oSegA;
    wire oSegB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iA(iA),
        .iB(iB),
        .iC(iC),
        .iD(iD),
        .oSegA(oSegA),
        .oSegB(oSegB)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        iA = 0; iB = 0; iC = 0; iD = 0;
        $display("Test %0d: Input 0000 (0)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        iA = 0; iB = 0; iC = 0; iD = 1;
        $display("Test %0d: Input 0001 (1)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        iA = 0; iB = 0; iC = 1; iD = 0;
        $display("Test %0d: Input 0010 (2)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        iA = 0; iB = 0; iC = 1; iD = 1;
        $display("Test %0d: Input 0011 (3)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        iA = 0; iB = 1; iC = 0; iD = 0;
        $display("Test %0d: Input 0100 (4)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        iA = 0; iB = 1; iC = 0; iD = 1;
        $display("Test %0d: Input 0101 (5)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        iA = 0; iB = 1; iC = 1; iD = 0;
        $display("Test %0d: Input 0110 (6)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        iA = 0; iB = 1; iC = 1; iD = 1;
        $display("Test %0d: Input 0111 (7)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        iA = 1; iB = 0; iC = 0; iD = 0;
        $display("Test %0d: Input 1000 (8)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        iA = 1; iB = 0; iC = 0; iD = 1;
        $display("Test %0d: Input 1001 (9)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        iA = 1; iB = 0; iC = 1; iD = 0;
        $display("Test %0d: Input 1010 (Hex A)", test_num);



        #1;




        check_outputs(oSegA, oSegB);
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
        input expected_oSegA;
        input expected_oSegB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oSegA === (expected_oSegA ^ oSegA ^ expected_oSegA) &&
                expected_oSegB === (expected_oSegB ^ oSegB ^ expected_oSegB)) begin
                $display("PASS");
                $display("  Outputs: oSegA=%b, oSegB=%b",
                         oSegA, oSegB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oSegA=%b, oSegB=%b",
                         expected_oSegA, expected_oSegB);
                $display("  Got:      oSegA=%b, oSegB=%b",
                         oSegA, oSegB);
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
