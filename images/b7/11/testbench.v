`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] PC;
    reg brancheq;
    reg branchneq;
    reg [1:0] control;
    reg [31:0] regOut;
    reg [31:0] signalExtend;
    reg [31:0] sumOut;
    reg zero;
    wire [31:0] PCout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC(PC),
        .brancheq(brancheq),
        .branchneq(branchneq),
        .control(control),
        .regOut(regOut),
        .signalExtend(signalExtend),
        .sumOut(sumOut),
        .zero(zero),
        .PCout(PCout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control 2'b00 - Branch Equal (Taken)", test_num);
            PC = 32'h0000_0004;
            sumOut = 32'h0000_0020;
            regOut = 32'h0000_00F0;
            signalExtend = 32'h0000_0100;
            zero = 1;
            brancheq = 1;
            branchneq = 0;
            control = 2'b00;
            #1;

            check_outputs(32'h0000_0020);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control 2'b00 - Branch Equal (Not Taken)", test_num);
            PC = 32'h0000_0004;
            sumOut = 32'h0000_0020;
            zero = 0;
            brancheq = 1;
            branchneq = 0;
            control = 2'b00;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control 2'b00 - Branch Not Equal (Taken)", test_num);
            PC = 32'h0000_0004;
            sumOut = 32'h0000_0040;
            zero = 0;
            brancheq = 0;
            branchneq = 1;
            control = 2'b00;
            #1;

            check_outputs(32'h0000_0040);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control 2'b00 - Branch Not Equal (Not Taken)", test_num);
            PC = 32'h0000_0004;
            sumOut = 32'h0000_0040;
            zero = 1;
            brancheq = 0;
            branchneq = 1;
            control = 2'b00;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control 2'b00 - No Branch Selected", test_num);
            PC = 32'h0000_0008;
            sumOut = 32'h0000_0050;
            zero = 1;
            brancheq = 0;
            branchneq = 0;
            control = 2'b00;
            #1;

            check_outputs(32'h0000_0008);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control 2'b01 - Signal Extend (Jump)", test_num);
            PC = 32'h0000_0004;
            signalExtend = 32'h0000_ABCD;
            control = 2'b01;
            #1;

            check_outputs(32'h0000_ABCD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control 2'b10 - Reg Out (Jump Register)", test_num);
            PC = 32'h0000_0004;
            regOut = 32'hFFFF_0000;
            control = 2'b10;
            #1;

            check_outputs(32'hFFFF_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control 2'b11 - Default Selection", test_num);
            PC = 32'h0000_1234;
            control = 2'b11;


            #1;



            check_outputs(32'h0000_1234);
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
        input [31:0] expected_PCout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PCout === (expected_PCout ^ PCout ^ expected_PCout)) begin
                $display("PASS");
                $display("  Outputs: PCout=%h",
                         PCout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PCout=%h",
                         expected_PCout);
                $display("  Got:      PCout=%h",
                         PCout);
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
