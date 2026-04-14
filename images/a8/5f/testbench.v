`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg branchLessResult;
    reg branchNotEqualResult;
    reg currentStatus;
    reg [4:0] opcode;
    wire shouldBranch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branchLessResult(branchLessResult),
        .branchNotEqualResult(branchNotEqualResult),
        .currentStatus(currentStatus),
        .opcode(opcode),
        .shouldBranch(shouldBranch)
    );
    task testcase001;

        begin
            test_num = 1;
            opcode = 5'b00000;
            branchLessResult = 1'b0;
            branchNotEqualResult = 1'b0;
            currentStatus = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            opcode = 5'b00001;
            branchLessResult = 1'b0;
            branchNotEqualResult = 1'b1;
            currentStatus = 1'b0;
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            opcode = 5'b00010;
            branchLessResult = 1'b1;
            branchNotEqualResult = 1'b0;
            currentStatus = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            opcode = 5'b00100;
            branchLessResult = 1'b0;
            branchNotEqualResult = 1'b0;
            currentStatus = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            opcode = 5'b00000;
            branchLessResult = 1'b0;
            branchNotEqualResult = 1'b1;
            currentStatus = 1'b0;
            #10;



            #1;




            check_outputs(shouldBranch);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            opcode = 5'b11111;
            branchLessResult = 1'b1;
            branchNotEqualResult = 1'b1;
            currentStatus = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            opcode = 5'b10101;
            branchLessResult = 1'b1;
            branchNotEqualResult = 1'b1;
            currentStatus = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            opcode = 5'b01010;
            branchLessResult = 1'b0;
            branchNotEqualResult = 1'b0;
            currentStatus = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
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
        input expected_shouldBranch;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shouldBranch === (expected_shouldBranch ^ shouldBranch ^ expected_shouldBranch)) begin
                $display("PASS");
                $display("  Outputs: shouldBranch=%b",
                         shouldBranch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shouldBranch=%b",
                         expected_shouldBranch);
                $display("  Got:      shouldBranch=%b",
                         shouldBranch);
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
