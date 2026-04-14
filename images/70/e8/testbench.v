`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg compare;
    reg [31:0] dinA;
    reg [31:0] dinB;
    reg [31:0] ins;
    wire branch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .compare(compare),
        .dinA(dinA),
        .dinB(dinB),
        .ins(ins),
        .branch(branch)
    );
    task set_ins;

        input [5:0] opcode;
        input [4:0] rt;
        begin
            ins = 32'b0;
            ins[31:26] = opcode;
            ins[20:16] = rt;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        compare = 1;
        dinA = 32'hAAAA_BBBB;
        dinB = 32'hAAAA_BBBB;
        set_ins(OP_BEQ, 5'b0);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        compare = 1;
        dinA = 32'hAAAA_BBBB;
        dinB = 32'h1234_5678;
        set_ins(OP_BEQ, 5'b0);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        compare = 1;
        dinA = 32'h5555_AAAA;
        dinB = 32'h0000_1111;
        set_ins(OP_BNE, 5'b0);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        compare = 1;
        dinA = 32'hFFFF_FFFF;
        dinB = 32'h0;
        set_ins(OP_BLEZ, 5'b0);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        compare = 1;
        dinA = 32'h0000_0000;
        dinB = 32'h0;
        set_ins(OP_BLEZ, 5'b0);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        compare = 1;
        dinA = 32'h0000_0005;
        dinB = 32'h0;
        set_ins(OP_BGTZ, 5'b0);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        compare = 1;
        dinA = 32'h8000_0000;
        dinB = 32'h0;
        set_ins(OP_REGIMM, RT_BLTZ);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        compare = 1;
        dinA = 32'h0000_0000;
        dinB = 32'h0;
        set_ins(OP_REGIMM, RT_BGEZ);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        compare = 1;
        dinA = 32'h7FFF_FFFF;
        dinB = 32'h0;
        set_ins(OP_REGIMM, RT_BGEZ);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        compare = 0;
        dinA = 32'h1234_1234;
        dinB = 32'h1234_1234;
        set_ins(OP_BEQ, 5'b0);
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
        testcase009();
        testcase010();
        
        
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
        input expected_branch;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_branch === (expected_branch ^ branch ^ expected_branch)) begin
                $display("PASS");
                $display("  Outputs: branch=%b",
                         branch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branch=%b",
                         expected_branch);
                $display("  Got:      branch=%b",
                         branch);
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
