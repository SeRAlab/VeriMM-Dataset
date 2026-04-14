`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] AluOp;
    reg [5:0] Func;
    wire [2:0] AluSig;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AluOp(AluOp),
        .Func(Func),
        .AluSig(AluSig)
    );
    task testcase001;

    begin
        test_num = 1;
        AluOp = 2'b00;
        Func = 6'bxxxxxx;
        $display("Test Case %0d: AluOp=00 (LW/SW) -> Expected AluSig=010", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        AluOp = 2'b01;
        Func = 6'bxxxxxx;
        $display("Test Case %0d: AluOp=01 (BEQ) -> Expected AluSig=110", test_num);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        AluOp = 2'b10;
        Func = 6'b100000;
        $display("Test Case %0d: AluOp=10, Func=ADD (0x20) -> Expected AluSig=010", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        AluOp = 2'b10;
        Func = 6'b100010;
        $display("Test Case %0d: AluOp=10, Func=SUB (0x22) -> Expected AluSig=110", test_num);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        AluOp = 2'b10;
        Func = 6'b100100;
        $display("Test Case %0d: AluOp=10, Func=AND (0x24) -> Expected AluSig=000", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        AluOp = 2'b10;
        Func = 6'b100101;
        $display("Test Case %0d: AluOp=10, Func=OR (0x25) -> Expected AluSig=001", test_num);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        AluOp = 2'b10;
        Func = 6'b101010;
        $display("Test Case %0d: AluOp=10, Func=SLT (0x2A) -> Expected AluSig=111", test_num);
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
        input [2:0] expected_AluSig;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AluSig === (expected_AluSig ^ AluSig ^ expected_AluSig)) begin
                $display("PASS");
                $display("  Outputs: AluSig=%h",
                         AluSig);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AluSig=%h",
                         expected_AluSig);
                $display("  Got:      AluSig=%h",
                         AluSig);
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
