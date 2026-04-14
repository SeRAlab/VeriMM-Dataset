`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ReadData1;
    reg [31:0] ReadData2;
    reg [2:0] funct3;
    reg [6:0] opCode;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .funct3(funct3),
        .opCode(opCode),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: BNE instruction (Valid opCode, funct3), Data Unequal", test_num);
            ReadData1 = 32'h12345678;
            ReadData2 = 32'h87654321;
            opCode = 7'b1100011;
            funct3 = 3'b001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: BNE instruction (Valid opCode, funct3), Data Equal", test_num);
            ReadData1 = 32'hABCDEF00;
            ReadData2 = 32'hABCDEF00;
            opCode = 7'b1100011;
            funct3 = 3'b001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Invalid opCode, valid funct3, Data Unequal", test_num);
            ReadData1 = 32'h00000001;
            ReadData2 = 32'h00000002;
            opCode = 7'b0000000;
            funct3 = 3'b001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Valid opCode, invalid funct3 (not BNE), Data Unequal", test_num);
            ReadData1 = 32'h00000001;
            ReadData2 = 32'h00000002;
            opCode = 7'b1100011;
            funct3 = 3'b000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Boundary values - Max vs 0, valid BNE", test_num);
            ReadData1 = 32'hFFFFFFFF;
            ReadData2 = 32'h00000000;
            opCode = 7'b1100011;
            funct3 = 3'b001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Both zero, valid BNE", test_num);
            ReadData1 = 32'h00000000;
            ReadData2 = 32'h00000000;
            opCode = 7'b1100011;
            funct3 = 3'b001;
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
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: zero=%b",
                         zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zero=%b",
                         expected_zero);
                $display("  Got:      zero=%b",
                         zero);
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
