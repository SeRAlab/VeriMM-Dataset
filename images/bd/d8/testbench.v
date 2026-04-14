`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] OpCode;
    wire DMemWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .OpCode(OpCode),
        .DMemWrite(DMemWrite)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing OpCode 10000 (DMemWrite should be 1)", test_num);
            OpCode = 5'b10000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing OpCode 10011 (DMemWrite should be 1)", test_num);
            OpCode = 5'b10011;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing OpCode 00000 (DMemWrite should be 0)", test_num);
            OpCode = 5'b00000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing OpCode 10001 (DMemWrite should be 0)", test_num);
            OpCode = 5'b10001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing OpCode 10010 (DMemWrite should be 0)", test_num);
            OpCode = 5'b10010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing OpCode 11111 (DMemWrite should be 0)", test_num);
            OpCode = 5'b11111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing OpCode 01010 (DMemWrite should be 0)", test_num);
            OpCode = 5'b01010;
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
        input expected_DMemWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DMemWrite === (expected_DMemWrite ^ DMemWrite ^ expected_DMemWrite)) begin
                $display("PASS");
                $display("  Outputs: DMemWrite=%b",
                         DMemWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DMemWrite=%b",
                         expected_DMemWrite);
                $display("  Got:      DMemWrite=%b",
                         DMemWrite);
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
