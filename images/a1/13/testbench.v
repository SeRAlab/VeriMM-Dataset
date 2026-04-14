`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] imm;
    wire [31:0] branch_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .imm(imm),
        .branch_address(branch_address)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Input", test_num);
            imm = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Positive Value", test_num);
            imm = 32'h00000001;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Bits Set (Check bottom 2 bits zero)", test_num);
            imm = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Hex Value", test_num);
            imm = 32'h12345678;
            #1;

            check_outputs(32'h48D159E0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Positive Word Address", test_num);
            imm = 32'h3FFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Upper Bits", test_num);
            imm = 32'hC0000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Pattern", test_num);
            imm = 32'hAAAAAAAA;
            #1;

            check_outputs(32'hAAAAAAA8);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower Nibble Shift", test_num);
            imm = 32'h0000000F;
            #1;

            check_outputs(32'h0000003C);
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
        input [31:0] expected_branch_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_branch_address === (expected_branch_address ^ branch_address ^ expected_branch_address)) begin
                $display("PASS");
                $display("  Outputs: branch_address=%h",
                         branch_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branch_address=%h",
                         expected_branch_address);
                $display("  Got:      branch_address=%h",
                         branch_address);
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
