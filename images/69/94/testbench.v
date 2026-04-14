`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire XOR_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .XOR_output(XOR_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing VPB=0, VNB=0", test_num);
            VPWR = 1;
            VGND = 0;
            VPB  = 0;
            VNB  = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing VPB=0, VNB=1", test_num);
            VPWR = 1;
            VGND = 0;
            VPB  = 0;
            VNB  = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing VPB=1, VNB=0", test_num);
            VPWR = 1;
            VGND = 0;
            VPB  = 1;
            VNB  = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing VPB=1, VNB=1", test_num);
            VPWR = 1;
            VGND = 0;
            VPB  = 1;
            VNB  = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing logic with power signals logic levels", test_num);

            VPWR = 0;
            VGND = 1;
            VPB  = 0;
            VNB  = 1;
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
        input expected_XOR_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_XOR_output === (expected_XOR_output ^ XOR_output ^ expected_XOR_output)) begin
                $display("PASS");
                $display("  Outputs: XOR_output=%b",
                         XOR_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: XOR_output=%b",
                         expected_XOR_output);
                $display("  Got:      XOR_output=%b",
                         XOR_output);
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
