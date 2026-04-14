`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    wire [127:0] shift;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .key(key),
        .shift(shift)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All zeros", test_num);
        key = 128'h0;
        #10;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All ones", test_num);
        key = {128{1'b1}};
        #10;
        #1;

        check_outputs({128{1'b1}});
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Simple rotation (11223344 -> 22334411)", test_num);
        key = 128'h00000000_00000000_00000000_11223344;
        #10;
        #1;

        check_outputs(128'h00000000_00000000_00000000_22334411);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Complex upper bits maintenance", test_num);
        key = 128'hAAAA_AAAA_BBBB_BBBB_CCCC_CCCC_8899AABB;
        #10;
        #1;

        check_outputs(128'hAAAA_AAAA_BBBB_BBBB_CCCC_CCCC_99AABB88);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single byte rotation boundary", test_num);
        key = 128'h01234567_89AB_CDEF_FEDC_BA98_000000FF;
        #10;
        #1;

        check_outputs(128'h01234567_89AB_CDEF_FEDC_BA98_0000FF00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: MSB byte to LSB position (DEADBEEF)", test_num);
        key = 128'hFFFF_0000_FFFF_0000_FFFF_0000_DEADBEEF;
        #10;
        #1;

        check_outputs(128'hFFFF_0000_FFFF_0000_FFFF_0000_ADBEEFDE);
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
        input [127:0] expected_shift;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shift === (expected_shift ^ shift ^ expected_shift)) begin
                $display("PASS");
                $display("  Outputs: shift=%h",
                         shift);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift=%h",
                         expected_shift);
                $display("  Got:      shift=%h",
                         shift);
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
