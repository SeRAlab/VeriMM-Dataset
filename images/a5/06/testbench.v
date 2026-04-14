`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire VGND_out;
    wire VNB_out;
    wire VPB_out;
    wire VPWR_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .VGND_out(VGND_out),
        .VNB_out(VNB_out),
        .VPB_out(VPB_out),
        .VPWR_out(VPWR_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verification of Fixed Voltage Levels", test_num);

            #10;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stability Check over time", test_num);

            #100;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
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
        input expected_VGND_out;
        input expected_VNB_out;
        input expected_VPB_out;
        input expected_VPWR_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_VGND_out === (expected_VGND_out ^ VGND_out ^ expected_VGND_out) &&
                expected_VNB_out === (expected_VNB_out ^ VNB_out ^ expected_VNB_out) &&
                expected_VPB_out === (expected_VPB_out ^ VPB_out ^ expected_VPB_out) &&
                expected_VPWR_out === (expected_VPWR_out ^ VPWR_out ^ expected_VPWR_out)) begin
                $display("PASS");
                $display("  Outputs: VGND_out=%b, VNB_out=%b, VPB_out=%b, VPWR_out=%b",
                         VGND_out, VNB_out, VPB_out, VPWR_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VGND_out=%b, VNB_out=%b, VPB_out=%b, VPWR_out=%b",
                         expected_VGND_out, expected_VNB_out, expected_VPB_out, expected_VPWR_out);
                $display("  Got:      VGND_out=%b, VNB_out=%b, VPB_out=%b, VPWR_out=%b",
                         VGND_out, VNB_out, VPB_out, VPWR_out);
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
