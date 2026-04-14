`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] Func;
    reg [5:0] Op;
    wire [3:0] ALUCntl;
    wire RegWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Func(Func),
        .Op(Op),
        .ALUCntl(ALUCntl),
        .RegWrite(RegWrite)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Op=0, Func=32 (ADD)", test_num);
            Op = 6'h00;
            Func = 6'h20;
            #1;

            check_outputs(4'h2, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Op=0, Func=34 (SUB)", test_num);
            Op = 6'h00;
            Func = 6'h22;
            #1;

            check_outputs(4'h6, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Op=0, Func=36 (AND)", test_num);
            Op = 6'h00;
            Func = 6'h24;
            #1;

            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Op=0, Func=37 (OR)", test_num);
            Op = 6'h00;
            Func = 6'h25;
            #1;

            check_outputs(4'h1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Op=0, Func=42 (SLT)", test_num);
            Op = 6'h00;
            Func = 6'h2A;
            #1;

            check_outputs(4'h7, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Op=35 (LW), Func=any", test_num);
            Op = 6'h23;
            Func = 6'h00;
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Op=8 (ADDI), Func=any", test_num);
            Op = 6'h08;
            Func = 6'h20;
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Op=4 (BEQ), Func=any", test_num);
            Op = 6'h04;
            Func = 6'h3F;
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Op=63 (Max), Func=any", test_num);
            Op = 6'h3F;
            Func = 6'h12;
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Op=0, Func=0 (Default/Other)", test_num);
            Op = 6'h00;
            Func = 6'h00;


            #1;



            check_outputs(ALUCntl, 1'b1);
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
        input [3:0] expected_ALUCntl;
        input expected_RegWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUCntl === (expected_ALUCntl ^ ALUCntl ^ expected_ALUCntl) &&
                expected_RegWrite === (expected_RegWrite ^ RegWrite ^ expected_RegWrite)) begin
                $display("PASS");
                $display("  Outputs: ALUCntl=%h, RegWrite=%b",
                         ALUCntl, RegWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUCntl=%h, RegWrite=%b",
                         expected_ALUCntl, expected_RegWrite);
                $display("  Got:      ALUCntl=%h, RegWrite=%b",
                         ALUCntl, RegWrite);
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
