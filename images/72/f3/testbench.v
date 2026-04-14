`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] funct;
    reg [5:0] opcode;
    wire immFlag;
    wire [11:0] opCodeOutputThing;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .funct(funct),
        .opcode(opcode),
        .immFlag(immFlag),
        .opCodeOutputThing(opCodeOutputThing)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All zeros", test_num);
            opcode = 6'h00;
            funct  = 6'h00;
            #1;

            check_outputs(1'b0, 12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Opcode 0, Funct non-zero", test_num);
            opcode = 6'h00;
            funct  = 6'h3F;
            #1;

            check_outputs(1'b0, 12'h03F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Opcode non-zero (MSB), Funct 0", test_num);
            opcode = 6'b100000;
            funct  = 6'h00;
            #1;

            check_outputs(1'b1, 12'h800);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Opcode non-zero (LSB), Funct 0", test_num);
            opcode = 6'b000001;
            funct  = 6'h00;
            #1;

            check_outputs(1'b1, 12'h040);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Mixed values", test_num);
            opcode = 6'b101010;
            funct  = 6'b010101;
            #1;

            check_outputs(1'b1, 12'hA95);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: All ones", test_num);
            opcode = 6'h3F;
            funct  = 6'h3F;
            #1;

            check_outputs(1'b1, 12'hFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Random pattern", test_num);
            opcode = 6'h12;
            funct  = 6'h24;
            #1;

            check_outputs(1'b1, 12'h4A4);
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
        input expected_immFlag;
        input [11:0] expected_opCodeOutputThing;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_immFlag === (expected_immFlag ^ immFlag ^ expected_immFlag) &&
                expected_opCodeOutputThing === (expected_opCodeOutputThing ^ opCodeOutputThing ^ expected_opCodeOutputThing)) begin
                $display("PASS");
                $display("  Outputs: immFlag=%b, opCodeOutputThing=%h",
                         immFlag, opCodeOutputThing);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: immFlag=%b, opCodeOutputThing=%h",
                         expected_immFlag, expected_opCodeOutputThing);
                $display("  Got:      immFlag=%b, opCodeOutputThing=%h",
                         immFlag, opCodeOutputThing);
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
