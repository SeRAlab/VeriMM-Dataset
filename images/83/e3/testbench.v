`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] AluOp;
    reg [5:0] Func;
    wire [2:0] AluCtrl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AluOp(AluOp),
        .Func(Func),
        .AluCtrl(AluCtrl)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: AluOp=00 (LW/SW)", test_num);
        AluOp = 2'b00;
        Func = 6'bxxxxxx;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: AluOp=01 (BEQ/BNE)", test_num);
        AluOp = 2'b01;
        Func = 6'bxxxxxx;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: AluOp=10, Func=100000 (ADD)", test_num);
        AluOp = 2'b10;
        Func = 6'b100000;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: AluOp=10, Func=100010 (SUB)", test_num);
        AluOp = 2'b10;
        Func = 6'b100010;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: AluOp=10, Func=100100 (AND)", test_num);
        AluOp = 2'b10;
        Func = 6'b100100;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: AluOp=10, Func=100101 (OR)", test_num);
        AluOp = 2'b10;
        Func = 6'b100101;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: AluOp=10, Func=101010 (SLT)", test_num);
        AluOp = 2'b10;
        Func = 6'b101010;
        #1;

        check_outputs(3'b111);
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
        input [2:0] expected_AluCtrl;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AluCtrl === (expected_AluCtrl ^ AluCtrl ^ expected_AluCtrl)) begin
                $display("PASS");
                $display("  Outputs: AluCtrl=%h",
                         AluCtrl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AluCtrl=%h",
                         expected_AluCtrl);
                $display("  Got:      AluCtrl=%h",
                         AluCtrl);
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
