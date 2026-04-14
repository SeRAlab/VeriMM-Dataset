`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input1;
    reg [31:0] input2;
    reg [31:0] inst;
    reg select;
    wire [31:0] output1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input2(input2),
        .inst(inst),
        .select(select),
        .output1(output1)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Branch Instruction (1100011), select=0", test_num);
        input1 = 32'hAAAAAAAA;
        input2 = 32'h55555555;
        inst   = 32'h00000063;
        select = 1'b0;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Branch Instruction (1100011), select=1", test_num);
        input1 = 32'hAAAAAAAA;
        input2 = 32'h55555555;
        inst   = 32'h00000063;
        select = 1'b1;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Non-Branch Instruction (0110011), select=0", test_num);
        input1 = 32'h12345678;
        input2 = 32'h9ABCDEF0;
        inst   = 32'h00000033;
        select = 1'b0;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Non-Branch Instruction (0110011), select=1", test_num);
        input1 = 32'h12345678;
        input2 = 32'h9ABCDEF0;
        inst   = 32'h00000033;
        select = 1'b1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Instruction with partial match (1100010), select=1", test_num);
        input1 = 32'hDEADBEEF;
        input2 = 32'hCAFEBABE;
        inst   = 32'h00000062;
        select = 1'b1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Branch Instruction with upper bits set, select=1", test_num);
        input1 = 32'h00000001;
        input2 = 32'hFFFFFFFF;
        inst   = 32'hABCDFE63;
        select = 1'b1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Opcode all ones (1111111), select=1", test_num);
        input1 = 32'h11112222;
        input2 = 32'h33334444;
        inst   = 32'h0000007F;
        select = 1'b1;
        #1;

        check_outputs(32'h11112222);
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
        input [31:0] expected_output1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output1 === (expected_output1 ^ output1 ^ expected_output1)) begin
                $display("PASS");
                $display("  Outputs: output1=%h",
                         output1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output1=%h",
                         expected_output1);
                $display("  Got:      output1=%h",
                         output1);
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
