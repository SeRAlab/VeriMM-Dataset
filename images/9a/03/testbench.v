`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DIODE;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire DIODE_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIODE(DIODE),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .DIODE_OUT(DIODE_OUT)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: DIODE set to LOW (0). Expected DIODE_OUT: 0", test_num);

        VPWR = 1'b1;
        VGND = 1'b0;
        VPB = 1'b1;
        VNB = 1'b0;

        DIODE = 1'b0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: DIODE set to HIGH (1). Expected DIODE_OUT: 1", test_num);

        VPWR = 1'b1;
        VGND = 1'b0;
        VPB = 1'b1;
        VNB = 1'b0;

        DIODE = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Power-down simulation (VPWR=0). Expected DIODE_OUT: 0", test_num);

        VPWR = 1'b0;
        VGND = 1'b0;
        VPB = 1'b0;
        VNB = 1'b0;

        DIODE = 1'b1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Toggle DIODE from HIGH back to LOW. Expected DIODE_OUT: 0", test_num);

        VPWR = 1'b1;
        VGND = 1'b0;
        VPB = 1'b1;
        VNB = 1'b0;

        DIODE = 1'b0;
        #10;
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
        input expected_DIODE_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DIODE_OUT === (expected_DIODE_OUT ^ DIODE_OUT ^ expected_DIODE_OUT)) begin
                $display("PASS");
                $display("  Outputs: DIODE_OUT=%b",
                         DIODE_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DIODE_OUT=%b",
                         expected_DIODE_OUT);
                $display("  Got:      DIODE_OUT=%b",
                         DIODE_OUT);
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
