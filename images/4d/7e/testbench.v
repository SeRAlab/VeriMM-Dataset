`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg I_EN;
    reg I_PAD_$inp;
    reg O_DAT;
    reg O_EN;
    wire I_DAT;
    wire O_PAD_$out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I_EN(I_EN),
        .I_PAD_$inp(I_PAD_$inp),
        .O_DAT(O_DAT),
        .O_EN(O_EN),
        .I_DAT(I_DAT),
        .O_PAD_$out(O_PAD_$out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Output drive active - Low", test_num);
            I_EN = 0;
            I_PAD_$inp = 0;
            O_DAT = 0;
            O_EN = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Output drive active - High", test_num);
            I_EN = 0;
            I_PAD_$inp = 0;
            O_DAT = 1;
            O_EN = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Output drive disabled (High-Z)", test_num);
            I_EN = 0;
            I_PAD_$inp = 0;
            O_DAT = 1;
            O_EN = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'bz);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Input buffer active - Low", test_num);
            I_EN = 1;
            I_PAD_$inp = 0;
            O_DAT = 0;
            O_EN = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'bz);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Input buffer active - High", test_num);
            I_EN = 1;
            I_PAD_$inp = 1;
            O_DAT = 0;
            O_EN = 0;
            #10;
            #1;

            check_outputs(1'b1, 1'bz);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Input buffer disabled (Gated)", test_num);
            I_EN = 0;
            I_PAD_$inp = 1;
            O_DAT = 0;
            O_EN = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'bz);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Simultaneous drive and read", test_num);
            I_EN = 1;
            I_PAD_$inp = 1;
            O_DAT = 0;
            O_EN = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: All signals disabled", test_num);
            I_EN = 0;
            I_PAD_$inp = 0;
            O_DAT = 0;
            O_EN = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'bz);
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
        input expected_I_DAT;
        input expected_O_PAD_$out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_I_DAT === (expected_I_DAT ^ I_DAT ^ expected_I_DAT) &&
                expected_O_PAD_$out === (expected_O_PAD_$out ^ O_PAD_$out ^ expected_O_PAD_$out)) begin
                $display("PASS");
                $display("  Outputs: I_DAT=%b, O_PAD_$out=%b",
                         I_DAT, O_PAD_$out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I_DAT=%b, O_PAD_$out=%b",
                         expected_I_DAT, expected_O_PAD_$out);
                $display("  Got:      I_DAT=%b, O_PAD_$out=%b",
                         I_DAT, O_PAD_$out);
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
