`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] OS1;
    reg [15:0] OS2;
    reg [15:0] OS3;
    reg [15:0] OS4;
    reg [15:0] OS5;
    wire [2:0] aSel2;
    wire [2:0] aSel3;
    wire [2:0] aSel4;
    wire [2:0] bSel2;
    wire [2:0] bSel3;
    wire [2:0] bSel4;
    wire [2:0] cSel2;
    wire [2:0] cSel3;
    wire [2:0] cSel4;
    wire [14:0] literalV;
    wire [6:0] op1;
    wire [6:0] op2;
    wire [6:0] op3;
    wire [6:0] op4;
    wire [6:0] op5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .OS1(OS1),
        .OS2(OS2),
        .OS3(OS3),
        .OS4(OS4),
        .OS5(OS5),
        .aSel2(aSel2),
        .aSel3(aSel3),
        .aSel4(aSel4),
        .bSel2(bSel2),
        .bSel3(bSel3),
        .bSel4(bSel4),
        .cSel2(cSel2),
        .cSel3(cSel3),
        .cSel4(cSel4),
        .literalV(literalV),
        .op1(op1),
        .op2(op2),
        .op3(op3),
        .op4(op4),
        .op5(op5)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Inputs Zero", test_num);

            OS1 = 16'h0000;
            OS2 = 16'h0000;
            OS3 = 16'h0000;
            OS4 = 16'h0000;
            OS5 = 16'h0000;




            #1;





            check_outputs(3'h0, 3'h0, 3'h0, 3'h0, 3'h0, 3'h0, 3'h0, 3'h0, 3'h0, 15'h0000, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Inputs High", test_num);

            OS1 = 16'h0000; OS2 = 16'h0000; OS3 = 16'h0000; OS4 = 16'h0000; OS5 = 16'h0000;
            #5;
            OS1 = 16'hFFFF;
            OS2 = 16'hFFFF;
            OS3 = 16'hFFFF;
            OS4 = 16'hFFFF;
            OS5 = 16'hFFFF;

            #1;


            check_outputs(3'h7, 3'h7, 3'h7, 3'h7, 3'h7, 3'h7, 3'h7, 3'h7, 3'h7, 15'h7FFF, 7'h7F, 7'h7F, 7'h7F, 7'h7F, 7'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Field Mapping Check", test_num);
            OS1 = 16'h0000; OS2 = 16'h0000; OS3 = 16'h0000; OS4 = 16'h0000; OS5 = 16'h0000;
            #5;
            OS1 = 16'h1234;
            OS2 = 16'h2345;
            OS3 = 16'h3456;
            OS4 = 16'h4567;
            OS5 = 16'h5678;

            #1;


            check_outputs(3'h6, 3'h0, 3'h2, 3'h0, 3'h5, 3'h1, 3'h1, 3'h1, 3'h2, 15'h2B3C, 7'h34, 7'h45, 7'h56, 7'h67, 7'h78);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bits", test_num);
            OS1 = 16'h0000; OS2 = 16'h0000; OS3 = 16'h0000; OS4 = 16'h0000; OS5 = 16'h0000;
            #5;
            OS1 = 16'hAAAA;
            OS2 = 16'h5555;
            OS3 = 16'hAAAA;
            OS4 = 16'h5555;
            OS5 = 16'hAAAA;

            #1;


            check_outputs(3'h2, 3'h5, 3'h2, 3'h5, 3'h2, 3'h5, 3'h2, 3'h5, 3'h2, 15'h5555, 7'h2A, 7'h55, 7'h2A, 7'h55, 7'h2A);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Bit Checks", test_num);
            OS1 = 16'h0000; OS2 = 16'h0000; OS3 = 16'h0000; OS4 = 16'h0000; OS5 = 16'h0000;
            #5;
            OS1 = 16'h0001;
            OS2 = 16'h0080;
            OS3 = 16'h0400;
            OS4 = 16'h2000;
            OS5 = 16'h8001;

            #1;


            check_outputs(3'h1, 3'h0, 3'h0, 3'h0, 3'h1, 3'h0, 3'h0, 3'h0, 3'h1, 15'h4000, 7'h01, 7'h00, 7'h00, 7'h00, 7'h01);
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
        input [2:0] expected_aSel2;
        input [2:0] expected_aSel3;
        input [2:0] expected_aSel4;
        input [2:0] expected_bSel2;
        input [2:0] expected_bSel3;
        input [2:0] expected_bSel4;
        input [2:0] expected_cSel2;
        input [2:0] expected_cSel3;
        input [2:0] expected_cSel4;
        input [14:0] expected_literalV;
        input [6:0] expected_op1;
        input [6:0] expected_op2;
        input [6:0] expected_op3;
        input [6:0] expected_op4;
        input [6:0] expected_op5;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aSel2 === (expected_aSel2 ^ aSel2 ^ expected_aSel2) &&
                expected_aSel3 === (expected_aSel3 ^ aSel3 ^ expected_aSel3) &&
                expected_aSel4 === (expected_aSel4 ^ aSel4 ^ expected_aSel4) &&
                expected_bSel2 === (expected_bSel2 ^ bSel2 ^ expected_bSel2) &&
                expected_bSel3 === (expected_bSel3 ^ bSel3 ^ expected_bSel3) &&
                expected_bSel4 === (expected_bSel4 ^ bSel4 ^ expected_bSel4) &&
                expected_cSel2 === (expected_cSel2 ^ cSel2 ^ expected_cSel2) &&
                expected_cSel3 === (expected_cSel3 ^ cSel3 ^ expected_cSel3) &&
                expected_cSel4 === (expected_cSel4 ^ cSel4 ^ expected_cSel4) &&
                expected_literalV === (expected_literalV ^ literalV ^ expected_literalV) &&
                expected_op1 === (expected_op1 ^ op1 ^ expected_op1) &&
                expected_op2 === (expected_op2 ^ op2 ^ expected_op2) &&
                expected_op3 === (expected_op3 ^ op3 ^ expected_op3) &&
                expected_op4 === (expected_op4 ^ op4 ^ expected_op4) &&
                expected_op5 === (expected_op5 ^ op5 ^ expected_op5)) begin
                $display("PASS");
                $display("  Outputs: aSel2=%h, aSel3=%h, aSel4=%h, bSel2=%h, bSel3=%h, bSel4=%h, cSel2=%h, cSel3=%h, cSel4=%h, literalV=%h, op1=%h, op2=%h, op3=%h, op4=%h, op5=%h",
                         aSel2, aSel3, aSel4, bSel2, bSel3, bSel4, cSel2, cSel3, cSel4, literalV, op1, op2, op3, op4, op5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aSel2=%h, aSel3=%h, aSel4=%h, bSel2=%h, bSel3=%h, bSel4=%h, cSel2=%h, cSel3=%h, cSel4=%h, literalV=%h, op1=%h, op2=%h, op3=%h, op4=%h, op5=%h",
                         expected_aSel2, expected_aSel3, expected_aSel4, expected_bSel2, expected_bSel3, expected_bSel4, expected_cSel2, expected_cSel3, expected_cSel4, expected_literalV, expected_op1, expected_op2, expected_op3, expected_op4, expected_op5);
                $display("  Got:      aSel2=%h, aSel3=%h, aSel4=%h, bSel2=%h, bSel3=%h, bSel4=%h, cSel2=%h, cSel3=%h, cSel4=%h, literalV=%h, op1=%h, op2=%h, op3=%h, op4=%h, op5=%h",
                         aSel2, aSel3, aSel4, bSel2, bSel3, bSel4, cSel2, cSel3, cSel4, literalV, op1, op2, op3, op4, op5);
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
