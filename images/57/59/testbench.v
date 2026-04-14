`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Imm;
    reg [31:0] PC;
    wire [31:0] PCimm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Imm(Imm),
        .PC(PC),
        .PCimm(PCimm)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive PC, Positive Imm", test_num);
            PC = 32'd100;
            Imm = 32'd4;
            #1;

            check_outputs(32'd104);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive PC, Negative Imm", test_num);
            PC = 32'd100;
            Imm = -32'd4;
            #1;

            check_outputs(32'd96);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative PC, Positive Imm", test_num);
            PC = -32'd10;
            Imm = 32'd20;
            #1;

            check_outputs(32'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both Zero", test_num);
            PC = 32'd0;
            Imm = 32'd0;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Positive PC, Small Positive Imm (Overflow)", test_num);
            PC = 32'h7FFFFFFF;
            Imm = 32'd1;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Min Negative PC, Small Negative Imm (Underflow)", test_num);
            PC = 32'h80000000;
            Imm = -32'd1;
            #1;

            check_outputs(32'h7FFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Negative Offset", test_num);
            PC = 32'h00001000;
            Imm = 32'hFFFFF000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Possible Value Sum", test_num);
            PC = 32'h7FFFFFFF;
            Imm = 32'h7FFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PC is Negative, Imm is Negative", test_num);
            PC = -32'd50;
            Imm = -32'd50;
            #1;

            check_outputs(-32'd100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Jump from zero to large address", test_num);
            PC = 32'h0;
            Imm = 32'h12345678;
            #1;

            check_outputs(32'h12345678);
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
        input [31:0] expected_PCimm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PCimm === (expected_PCimm ^ PCimm ^ expected_PCimm)) begin
                $display("PASS");
                $display("  Outputs: PCimm=%h",
                         PCimm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PCimm=%h",
                         expected_PCimm);
                $display("  Got:      PCimm=%h",
                         PCimm);
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
