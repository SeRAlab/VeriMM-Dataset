`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg Op;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Op(Op),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select A (Op=1) with standard values", test_num);
        A = 32'hDEADBEEF;
        B = 32'hCAFEBABE;
        Op = 1'b1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select B (Op=0) with standard values", test_num);
        A = 32'hDEADBEEF;
        B = 32'hCAFEBABE;
        Op = 1'b0;
        #1;

        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select A (Op=1) with all zeros and all ones", test_num);
        A = 32'h00000000;
        B = 32'hFFFFFFFF;
        Op = 1'b1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select B (Op=0) with all zeros and all ones", test_num);
        A = 32'h00000000;
        B = 32'hFFFFFFFF;
        Op = 1'b0;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select A (Op=1) with alternating patterns", test_num);
        A = 32'h55555555;
        B = 32'hAAAAAAAA;
        Op = 1'b1;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select B (Op=0) with alternating patterns", test_num);
        A = 32'h55555555;
        B = 32'hAAAAAAAA;
        Op = 1'b0;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select A (Op=1) with random-like hex", test_num);
        A = 32'h12345678;
        B = 32'h87654321;
        Op = 1'b1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select B (Op=0) with random-like hex", test_num);
        A = 32'h12345678;
        B = 32'h87654321;
        Op = 1'b0;
        #1;

        check_outputs(32'h87654321);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
