`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] opcode;
    wire [3:0] EX;
    wire [2:0] M;
    wire [1:0] WB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .opcode(opcode),
        .EX(EX),
        .M(M),
        .WB(WB)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        opcode = 6'b000000;
        #10;
        #1;

        check_outputs(4'b1100, 3'b000, 2'b10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        opcode = 6'b100011;
        #10;
        #1;

        check_outputs(4'b0001, 3'b010, 2'b11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        opcode = 6'b101011;
        #10;
        #1;

        check_outputs(4'b0001, 3'b001, 2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        opcode = 6'b000100;
        #10;
        #1;

        check_outputs(4'b0010, 3'b100, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        opcode = 6'b001000;
        #10;
        #1;

        check_outputs(4'b0001, 3'b000, 2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        opcode = 6'b000010;
        #10;
        #1;

        check_outputs(4'b0000, 3'b000, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        opcode = 6'b111111;
        #10;
        #1;

        check_outputs(4'b0000, 3'b000, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        opcode = 6'b010101;
        #10;
        #1;

        check_outputs(4'b0000, 3'b000, 2'b00);
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
        input [3:0] expected_EX;
        input [2:0] expected_M;
        input [1:0] expected_WB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EX === (expected_EX ^ EX ^ expected_EX) &&
                expected_M === (expected_M ^ M ^ expected_M) &&
                expected_WB === (expected_WB ^ WB ^ expected_WB)) begin
                $display("PASS");
                $display("  Outputs: EX=%h, M=%h, WB=%h",
                         EX, M, WB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EX=%h, M=%h, WB=%h",
                         expected_EX, expected_M, expected_WB);
                $display("  Got:      EX=%h, M=%h, WB=%h",
                         EX, M, WB);
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
