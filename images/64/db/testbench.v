`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg directCtrlPol;
    reg directCtrlRate;
    reg sendPacketPol;
    reg sendPacketRate;
    reg sendPacketSel;
    wire fullSpeedPol;
    wire fullSpeedRate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .directCtrlPol(directCtrlPol),
        .directCtrlRate(directCtrlRate),
        .sendPacketPol(sendPacketPol),
        .sendPacketRate(sendPacketRate),
        .sendPacketSel(sendPacketSel),
        .fullSpeedPol(fullSpeedPol),
        .fullSpeedRate(fullSpeedRate)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Selecting direct control (Rate=0, Pol=0)", test_num);
        sendPacketSel = 0;
        directCtrlRate = 0;
        directCtrlPol = 0;
        sendPacketRate = 1;
        sendPacketPol = 1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Selecting direct control (Rate=1, Pol=1)", test_num);
        sendPacketSel = 0;
        directCtrlRate = 1;
        directCtrlPol = 1;
        sendPacketRate = 0;
        sendPacketPol = 0;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Selecting send packet (Rate=0, Pol=0)", test_num);
        sendPacketSel = 1;
        sendPacketRate = 0;
        sendPacketPol = 0;
        directCtrlRate = 1;
        directCtrlPol = 1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Selecting send packet (Rate=1, Pol=1)", test_num);
        sendPacketSel = 1;
        sendPacketRate = 1;
        sendPacketPol = 1;
        directCtrlRate = 0;
        directCtrlPol = 0;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Mixed inputs, select direct (Rate=1, Pol=0)", test_num);
        sendPacketSel = 0;
        directCtrlRate = 1;
        directCtrlPol = 0;
        sendPacketRate = 0;
        sendPacketPol = 1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Mixed inputs, select send packet (Rate=0, Pol=1)", test_num);
        sendPacketSel = 1;
        directCtrlRate = 1;
        directCtrlPol = 0;
        sendPacketRate = 0;
        sendPacketPol = 1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Verify inactive inputs do not affect output (Sel=0)", test_num);
        sendPacketSel = 0;
        directCtrlRate = 1;
        directCtrlPol = 1;
        sendPacketRate = 0;
        sendPacketPol = 0;
        #5;
        sendPacketRate = 1;
        sendPacketPol = 1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Verify inactive inputs do not affect output (Sel=1)", test_num);
        sendPacketSel = 1;
        sendPacketRate = 0;
        sendPacketPol = 0;
        directCtrlRate = 1;
        directCtrlPol = 1;
        #5;
        directCtrlRate = 0;
        directCtrlPol = 0;
        #1;

        check_outputs(0, 0);
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
        input expected_fullSpeedPol;
        input expected_fullSpeedRate;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fullSpeedPol === (expected_fullSpeedPol ^ fullSpeedPol ^ expected_fullSpeedPol) &&
                expected_fullSpeedRate === (expected_fullSpeedRate ^ fullSpeedRate ^ expected_fullSpeedRate)) begin
                $display("PASS");
                $display("  Outputs: fullSpeedPol=%b, fullSpeedRate=%b",
                         fullSpeedPol, fullSpeedRate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fullSpeedPol=%b, fullSpeedRate=%b",
                         expected_fullSpeedPol, expected_fullSpeedRate);
                $display("  Got:      fullSpeedPol=%b, fullSpeedRate=%b",
                         fullSpeedPol, fullSpeedRate);
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
