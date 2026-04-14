`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [3:0] mask_id;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mask_id(mask_id)
    );
    task testcase001;

        reg [3:0] expected_mask;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Full Logic Verification", test_num);
            $display("Description: Calculating expected parity for each ID parameter [bits 9:1]");



            expected_mask[0] = ^dut.id0_m[9:1];
            expected_mask[1] = ^dut.id1_m[9:1];
            expected_mask[2] = ^dut.id2_m[9:1];
            expected_mask[3] = ^dut.id3_m[9:1];

            $display("  Internal Values: id0_m=%h, id1_m=%h, id2_m=%h, id3_m=%h",
                     dut.id0_m, dut.id1_m, dut.id2_m, dut.id3_m);

            #1;


            check_outputs(expected_mask);
        end
        endtask

    task testcase002;

        reg [3:0] initial_val;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Stability Check", test_num);
            $display("Description: Ensuring the combinational mask_id remains stable.");

            initial_val = mask_id;
            #50;

            if (mask_id === initial_val) begin
                $display("PASS: Output is stable.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output drifted! Initial: %h, Current: %h", initial_val, mask_id);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: X/Z State Verification", test_num);
            $display("Description: Checking for undefined or high-impedance bits in the output.");

            if (^mask_id === 1'bx || ^mask_id === 1'bz) begin
                $display("FAIL: Output contains unknown (X) or high-impedance (Z) states.");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Output contains valid binary data.");
                pass_count = pass_count + 1;
            end
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
        input [3:0] expected_mask_id;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mask_id === (expected_mask_id ^ mask_id ^ expected_mask_id)) begin
                $display("PASS");
                $display("  Outputs: mask_id=%h",
                         mask_id);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mask_id=%h",
                         expected_mask_id);
                $display("  Got:      mask_id=%h",
                         mask_id);
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
