`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg BRANCH_IN;
    reg [31:0] VAL_IN;
    wire BRANCH_OUT;
    wire RESET_2;
    wire [31:0] VAL_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BRANCH_IN(BRANCH_IN),
        .VAL_IN(VAL_IN),
        .BRANCH_OUT(BRANCH_OUT),
        .RESET_2(RESET_2),
        .VAL_OUT(VAL_OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Branch asserted high with sample value", test_num);
            BRANCH_IN = 1'b1;
            VAL_IN = 32'hABCD_1234;

            #1;


            check_outputs(1'b1, 1'b1, 32'hABCD_1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Branch de-asserted low with different value", test_num);
            BRANCH_IN = 1'b0;
            VAL_IN = 32'h5555_AAAA;

            #1;


            check_outputs(1'b0, 1'b0, 32'h5555_AAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Branch asserted high with all ones value", test_num);
            BRANCH_IN = 1'b1;
            VAL_IN = 32'hFFFF_FFFF;

            #1;


            check_outputs(1'b1, 1'b1, 32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Branch de-asserted low with zero value", test_num);
            BRANCH_IN = 1'b0;
            VAL_IN = 32'h0000_0000;

            #1;


            check_outputs(1'b0, 1'b0, 32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Branch asserted high with alternating bits", test_num);
            BRANCH_IN = 1'b1;
            VAL_IN = 32'hA5A5_5A5A;

            #1;


            check_outputs(1'b1, 1'b1, 32'hA5A5_5A5A);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify output transition from High to Low", test_num);

            BRANCH_IN = 1'b1;
            VAL_IN = 32'h1234_5678;
            #5;

            BRANCH_IN = 1'b0;
            VAL_IN = 32'h8765_4321;

            #1;


            check_outputs(1'b0, 1'b0, 32'h8765_4321);
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
        input expected_BRANCH_OUT;
        input expected_RESET_2;
        input [31:0] expected_VAL_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BRANCH_OUT === (expected_BRANCH_OUT ^ BRANCH_OUT ^ expected_BRANCH_OUT) &&
                expected_RESET_2 === (expected_RESET_2 ^ RESET_2 ^ expected_RESET_2) &&
                expected_VAL_OUT === (expected_VAL_OUT ^ VAL_OUT ^ expected_VAL_OUT)) begin
                $display("PASS");
                $display("  Outputs: BRANCH_OUT=%b, RESET_2=%b, VAL_OUT=%h",
                         BRANCH_OUT, RESET_2, VAL_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BRANCH_OUT=%b, RESET_2=%b, VAL_OUT=%h",
                         expected_BRANCH_OUT, expected_RESET_2, expected_VAL_OUT);
                $display("  Got:      BRANCH_OUT=%b, RESET_2=%b, VAL_OUT=%h",
                         BRANCH_OUT, RESET_2, VAL_OUT);
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
