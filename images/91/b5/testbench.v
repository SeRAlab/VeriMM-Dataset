`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [27:0] Instruction;
    reg [31:0] PCAddResult;
    wire [31:0] JumpAddress;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Instruction(Instruction),
        .PCAddResult(PCAddResult),
        .JumpAddress(JumpAddress)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            Instruction = 28'h0000000;
            PCAddResult = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            Instruction = 28'hFFFFFFF;
            PCAddResult = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High PC bits selection", test_num);
            Instruction = 28'h0000000;
            PCAddResult = 32'hA0000000;
            #1;

            check_outputs(32'hA0000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High PC bits with Instruction pattern", test_num);
            Instruction = 28'h5555555;
            PCAddResult = 32'h30000000;
            #1;

            check_outputs(32'h35555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Changing only Instruction bits", test_num);
            Instruction = 28'hABCD123;
            PCAddResult = 32'h4FFFFFFF;
            #1;

            check_outputs(32'h4ABCD123);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating PC and Instruction bits", test_num);
            Instruction = 28'hAAAAAAA;
            PCAddResult = 32'h50000000;
            #1;

            check_outputs(32'h5AAAAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary check for upper 4 bits", test_num);
            Instruction = 28'h0123456;
            PCAddResult = 32'hEFFFFFF1;
            #1;

            check_outputs(32'hE0123456);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lower PC bits do not affect JumpAddress", test_num);
            Instruction = 28'h7654321;
            PCAddResult = 32'hB1234567;
            #1;

            check_outputs(32'hB7654321);
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
        input [31:0] expected_JumpAddress;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_JumpAddress === (expected_JumpAddress ^ JumpAddress ^ expected_JumpAddress)) begin
                $display("PASS");
                $display("  Outputs: JumpAddress=%h",
                         JumpAddress);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: JumpAddress=%h",
                         expected_JumpAddress);
                $display("  Got:      JumpAddress=%h",
                         JumpAddress);
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
