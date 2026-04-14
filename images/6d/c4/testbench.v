`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [27:0] Inst;
    reg [3:0] PC;
    wire [31:0] jump;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Inst(Inst),
        .PC(PC),
        .jump(jump)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            PC = 4'h0;
            Inst = 28'h0000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            PC = 4'hF;
            Inst = 28'hFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (Pattern A/5)", test_num);
            PC = 4'hA;
            Inst = 28'h5555555;
            #1;

            check_outputs(32'hA5555555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (Pattern 5/A)", test_num);
            PC = 4'h5;
            Inst = 28'hAAAAAAA;
            #1;

            check_outputs(32'h5AAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low PC, High Inst Bits", test_num);
            PC = 4'h1;
            Inst = 28'hF000000;
            #1;

            check_outputs(32'h1F000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High PC, Low Inst Bits", test_num);
            PC = 4'hE;
            Inst = 28'h000000F;
            #1;

            check_outputs(32'hE000000F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern 1", test_num);
            PC = 4'h8;
            Inst = 28'h1234567;
            #1;

            check_outputs(32'h81234567);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern 2", test_num);
            PC = 4'h3;
            Inst = 28'hBCDEF01;
            #1;

            check_outputs(32'h3BCDEF01);
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
        input [31:0] expected_jump;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_jump === (expected_jump ^ jump ^ expected_jump)) begin
                $display("PASS");
                $display("  Outputs: jump=%h",
                         jump);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: jump=%h",
                         expected_jump);
                $display("  Got:      jump=%h",
                         jump);
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
