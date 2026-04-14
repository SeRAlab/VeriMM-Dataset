`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg AM3;
    reg AM32;
    reg AMCBit;
    reg RomInexactRound;
    reg SNnotDB;
    reg notAM2_0;
    reg notAM31_3;
    wire Inexact;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AM3(AM3),
        .AM32(AM32),
        .AMCBit(AMCBit),
        .RomInexactRound(RomInexactRound),
        .SNnotDB(SNnotDB),
        .notAM2_0(notAM2_0),
        .notAM31_3(notAM31_3),
        .Inexact(Inexact)
    );
    task set_inputs;

        input i_RomInexactRound;
        input i_SNnotDB;
        input i_AMCBit;
        input i_AM32;
        input i_AM3;
        input i_notAM31_3;
        input i_notAM2_0;
        begin
            RomInexactRound = i_RomInexactRound;
            SNnotDB = i_SNnotDB;
            AMCBit = i_AMCBit;
            AM32 = i_AM32;
            AM3 = i_AM3;
            notAM31_3 = i_notAM31_3;
            notAM2_0 = i_notAM2_0;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs zero", test_num);
        set_inputs(0, 0, 0, 0, 0, 0, 0);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: RomInexactRound active", test_num);
        set_inputs(1, 0, 0, 0, 0, 0, 0);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: AMCBit active", test_num);
        set_inputs(0, 0, 1, 0, 0, 0, 0);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Single Precision (SNnotDB) with AM32", test_num);

        set_inputs(0, 1, 0, 1, 0, 0, 0);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Double Precision (SNnotDB=0) with AM3", test_num);
        set_inputs(0, 0, 0, 0, 1, 0, 0);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Range indicator notAM31_3 logic", test_num);

        set_inputs(0, 0, 0, 0, 0, 0, 1);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Range indicator notAM2_0 logic", test_num);
        set_inputs(0, 0, 0, 0, 0, 1, 0);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: All inputs high", test_num);
        set_inputs(1, 1, 1, 1, 1, 1, 1);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Mixed precision indicators", test_num);
        set_inputs(0, 1, 0, 0, 1, 1, 1);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Edge case with inverted indicator flags", test_num);
        set_inputs(0, 0, 0, 1, 0, 0, 0);
        #1;

        check_outputs(1'b1);
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
        input expected_Inexact;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Inexact === (expected_Inexact ^ Inexact ^ expected_Inexact)) begin
                $display("PASS");
                $display("  Outputs: Inexact=%b",
                         Inexact);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Inexact=%b",
                         expected_Inexact);
                $display("  Got:      Inexact=%b",
                         Inexact);
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
