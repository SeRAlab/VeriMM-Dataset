`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] iTypeSignExtend;
    reg [31:0] rs1;
    wire [31:0] target;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iTypeSignExtend(iTypeSignExtend),
        .rs1(rs1),
        .target(target)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple positive addition", test_num);
            rs1 = 32'h00001000;
            iTypeSignExtend = 32'h00000004;
            #1;

            check_outputs(32'h00001004);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero inputs", test_num);
            rs1 = 32'h00000000;
            iTypeSignExtend = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative immediate (Two's Complement)", test_num);
            rs1 = 32'h00001000;
            iTypeSignExtend = 32'hFFFFFFFC;
            #1;

            check_outputs(32'h00000FFC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large register value and positive immediate", test_num);
            rs1 = 32'h80000000;
            iTypeSignExtend = 32'h00000001;
            #1;

            check_outputs(32'h80000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow wrap-around", test_num);
            rs1 = 32'hFFFFFFFF;
            iTypeSignExtend = 32'h00000001;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Both negative values", test_num);
            rs1 = 32'hFFFFFFFE;
            iTypeSignExtend = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random pattern addition", test_num);
            rs1 = 32'h12345678;
            iTypeSignExtend = 32'h87654321;
            #1;

            check_outputs(32'h99999999);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum immediate value addition", test_num);
            rs1 = 32'h00000001;
            iTypeSignExtend = 32'h7FFFFFFF;
            #1;

            check_outputs(32'h80000000);
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
        input [31:0] expected_target;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_target === (expected_target ^ target ^ expected_target)) begin
                $display("PASS");
                $display("  Outputs: target=%h",
                         target);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: target=%h",
                         expected_target);
                $display("  Got:      target=%h",
                         target);
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
