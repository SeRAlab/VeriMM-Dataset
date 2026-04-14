`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] In1;
    reg [31:0] In2;
    reg Op;
    wire [31:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In1(In1),
        .In2(In2),
        .Op(Op),
        .Out(Out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select In1 (Op=0) with basic values");
            In1 = 32'hAAAAAAAA;
            In2 = 32'h55555555;
            Op = 1'b0;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select In2 (Op=1) with basic values");
            In1 = 32'hAAAAAAAA;
            In2 = 32'h55555555;
            Op = 1'b1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Op=0, verify all bits at 1 move correctly");
            In1 = 32'hFFFFFFFF;
            In2 = 32'h00000000;
            Op = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Op=1, verify all bits at 1 move correctly");
            In1 = 32'h00000000;
            In2 = 32'hFFFFFFFF;
            Op = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Op=0, verify all bits at 0 move correctly");
            In1 = 32'h00000000;
            In2 = 32'hFFFFFFFF;
            Op = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Op=1, verify all bits at 0 move correctly");
            In1 = 32'hFFFFFFFF;
            In2 = 32'h00000000;
            Op = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Random pattern selection In1");
            In1 = 32'h12345678;
            In2 = 32'h9ABCDEF0;
            Op = 1'b0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Random pattern selection In2");
            In1 = 32'hDEADBEEF;
            In2 = 32'hCAFEBABE;
            Op = 1'b1;
            #1;

            check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
