`timescale 1ns/1ps

module speedCtrlMux_tb;

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
    speedCtrlMux dut (
        .directCtrlPol(directCtrlPol),
        .directCtrlRate(directCtrlRate),
        .sendPacketPol(sendPacketPol),
        .sendPacketRate(sendPacketRate),
        .sendPacketSel(sendPacketSel),
        .fullSpeedPol(fullSpeedPol),
        .fullSpeedRate(fullSpeedRate)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("speedCtrlMux Testbench");
        $display("========================================");


        
        
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
