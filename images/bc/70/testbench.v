`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] imm;
    wire [31:0] ID_imm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .imm(imm),
        .ID_imm(ID_imm)
    );
    task testcase001;

        begin
            test_num = 1;
            imm = 16'h0000;
            $display("Test Case 001: Input = %h", imm);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            imm = 16'h0001;
            $display("Test Case 002: Input = %h", imm);
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            imm = 16'h7FFF;
            $display("Test Case 003: Input = %h", imm);
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            imm = 16'h8000;
            $display("Test Case 004: Input = %h", imm);
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            imm = 16'hFFFF;
            $display("Test Case 005: Input = %h", imm);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            imm = 16'hA5A5;
            $display("Test Case 006: Input = %h", imm);
            #1;

            check_outputs(32'hFFFFA5A5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            imm = 16'h5A5A;
            $display("Test Case 007: Input = %h", imm);
            #1;

            check_outputs(32'h00005A5A);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            imm = 16'h8001;
            $display("Test Case 008: Input = %h", imm);
            #1;

            check_outputs(32'hFFFF8001);
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
        input [31:0] expected_ID_imm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ID_imm === (expected_ID_imm ^ ID_imm ^ expected_ID_imm)) begin
                $display("PASS");
                $display("  Outputs: ID_imm=%h",
                         ID_imm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ID_imm=%h",
                         expected_ID_imm);
                $display("  Got:      ID_imm=%h",
                         ID_imm);
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
