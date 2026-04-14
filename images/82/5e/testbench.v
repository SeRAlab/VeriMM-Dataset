`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg iNEXT_BUSY;
    reg iPREV_BRANCH_IB_VALID;
    reg [31:0] iPREV_BRANCH_PREDICT_ADDR;
    reg iPREV_BRANCH_PREDICT_ENA;
    reg iPREV_BRANCH_VALID;
    reg iPREV_EX_BRANCH;
    reg [31:0] iPREV_JUMP_ADDR;
    reg iPREV_VALID;
    reg iSTATE_NORMAL;
    wire oNEXT_PREDICT_HIT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iNEXT_BUSY(iNEXT_BUSY),
        .iPREV_BRANCH_IB_VALID(iPREV_BRANCH_IB_VALID),
        .iPREV_BRANCH_PREDICT_ADDR(iPREV_BRANCH_PREDICT_ADDR),
        .iPREV_BRANCH_PREDICT_ENA(iPREV_BRANCH_PREDICT_ENA),
        .iPREV_BRANCH_VALID(iPREV_BRANCH_VALID),
        .iPREV_EX_BRANCH(iPREV_EX_BRANCH),
        .iPREV_JUMP_ADDR(iPREV_JUMP_ADDR),
        .iPREV_VALID(iPREV_VALID),
        .iSTATE_NORMAL(iSTATE_NORMAL),
        .oNEXT_PREDICT_HIT(oNEXT_PREDICT_HIT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Perfect Prediction Hit", test_num);
            iSTATE_NORMAL = 1;
            iPREV_VALID = 1;
            iPREV_EX_BRANCH = 1;
            iPREV_BRANCH_PREDICT_ENA = 1;
            iPREV_BRANCH_PREDICT_ADDR = 32'h1000_0004;
            iPREV_BRANCH_VALID = 1;
            iPREV_BRANCH_IB_VALID = 0;
            iPREV_JUMP_ADDR = 32'h1000_0004;
            iNEXT_BUSY = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Prediction Address Mismatch", test_num);
            iSTATE_NORMAL = 1;
            iPREV_VALID = 1;
            iPREV_EX_BRANCH = 1;
            iPREV_BRANCH_PREDICT_ENA = 1;
            iPREV_BRANCH_PREDICT_ADDR = 32'h1000_0004;
            iPREV_BRANCH_VALID = 1;
            iPREV_BRANCH_IB_VALID = 0;
            iPREV_JUMP_ADDR = 32'h2000_0000;
            iNEXT_BUSY = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: State Not Normal", test_num);
            iSTATE_NORMAL = 0;
            iPREV_VALID = 1;
            iPREV_EX_BRANCH = 1;
            iPREV_BRANCH_PREDICT_ENA = 1;
            iPREV_BRANCH_PREDICT_ADDR = 32'h1000_0004;
            iPREV_BRANCH_VALID = 1;
            iPREV_BRANCH_IB_VALID = 0;
            iPREV_JUMP_ADDR = 32'h1000_0004;
            iNEXT_BUSY = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Downstream Busy", test_num);
            iSTATE_NORMAL = 1;
            iPREV_VALID = 1;
            iPREV_EX_BRANCH = 1;
            iPREV_BRANCH_PREDICT_ENA = 1;
            iPREV_BRANCH_PREDICT_ADDR = 32'h1000_0004;
            iPREV_BRANCH_VALID = 1;
            iPREV_BRANCH_IB_VALID = 0;
            iPREV_JUMP_ADDR = 32'h1000_0004;
            iNEXT_BUSY = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Indirect Branch Hit", test_num);
            iSTATE_NORMAL = 1;
            iPREV_VALID = 1;
            iPREV_EX_BRANCH = 1;
            iPREV_BRANCH_PREDICT_ENA = 1;
            iPREV_BRANCH_PREDICT_ADDR = 32'hFFFF_0000;
            iPREV_BRANCH_VALID = 0;
            iPREV_BRANCH_IB_VALID = 1;
            iPREV_JUMP_ADDR = 32'hFFFF_0000;
            iNEXT_BUSY = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Prediction Not Enabled", test_num);
            iSTATE_NORMAL = 1;
            iPREV_VALID = 1;
            iPREV_EX_BRANCH = 1;
            iPREV_BRANCH_PREDICT_ENA = 0;
            iPREV_BRANCH_PREDICT_ADDR = 32'h1000_0004;
            iPREV_BRANCH_VALID = 1;
            iPREV_BRANCH_IB_VALID = 0;
            iPREV_JUMP_ADDR = 32'h1000_0004;
            iNEXT_BUSY = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Not a Branch Instruction", test_num);
            iSTATE_NORMAL = 1;
            iPREV_VALID = 1;
            iPREV_EX_BRANCH = 0;
            iPREV_BRANCH_PREDICT_ENA = 1;
            iPREV_BRANCH_PREDICT_ADDR = 32'h1000_0004;
            iPREV_BRANCH_VALID = 1;
            iPREV_BRANCH_IB_VALID = 0;
            iPREV_JUMP_ADDR = 32'h1000_0004;
            iNEXT_BUSY = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Branch Resolution Invalid", test_num);
            iSTATE_NORMAL = 1;
            iPREV_VALID = 1;
            iPREV_EX_BRANCH = 1;
            iPREV_BRANCH_PREDICT_ENA = 1;
            iPREV_BRANCH_PREDICT_ADDR = 32'h1000_0004;
            iPREV_BRANCH_VALID = 0;
            iPREV_BRANCH_IB_VALID = 0;
            iPREV_JUMP_ADDR = 32'h1000_0004;
            iNEXT_BUSY = 0;
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
        input expected_oNEXT_PREDICT_HIT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oNEXT_PREDICT_HIT === (expected_oNEXT_PREDICT_HIT ^ oNEXT_PREDICT_HIT ^ expected_oNEXT_PREDICT_HIT)) begin
                $display("PASS");
                $display("  Outputs: oNEXT_PREDICT_HIT=%b",
                         oNEXT_PREDICT_HIT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oNEXT_PREDICT_HIT=%b",
                         expected_oNEXT_PREDICT_HIT);
                $display("  Got:      oNEXT_PREDICT_HIT=%b",
                         oNEXT_PREDICT_HIT);
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
