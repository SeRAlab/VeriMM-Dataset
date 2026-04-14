`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg rest;
    wire [15:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .rest(rest),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Assertion", test_num);
            rest = 1'b1;
            A = 16'hABCD;
            B = 16'h1234;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition", test_num);
            rest = 1'b0;
            A = 16'd100;
            B = 16'd250;
            #1;

            check_outputs(16'd350);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values / Overflow", test_num);
            rest = 1'b0;
            A = 16'hFFFF;
            B = 16'h0001;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Inputs", test_num);
            rest = 1'b0;
            A = 16'h0000;
            B = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern Test (AAAA + 5555)", test_num);
            rest = 1'b0;
            A = 16'hAAAA;
            B = 16'h5555;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset to Operation Transition", test_num);

            rest = 1'b1;
            A = 16'h1234;
            B = 16'h1234;
            #5;

            rest = 1'b0;
            #1;

            check_outputs(16'h2468);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Hex Values", test_num);
            rest = 1'b0;
            A = 16'h7000;
            B = 16'h8000;
            #1;

            check_outputs(16'hF000);
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
        input [15:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
