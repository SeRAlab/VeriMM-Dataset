`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [90:0] wrap64_setPerms_cap;
    reg [30:0] wrap64_setPerms_perms;
    wire [90:0] wrap64_setPerms;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wrap64_setPerms_cap(wrap64_setPerms_cap),
        .wrap64_setPerms_perms(wrap64_setPerms_perms),
        .wrap64_setPerms(wrap64_setPerms)
    );
    task testcase001;

        begin
            test_num = 1;
            wrap64_setPerms_cap = 91'h0;
            wrap64_setPerms_perms = 31'h0;
            #1;

            check_outputs({wrap64_setPerms_cap[90:50], wrap64_setPerms_perms[11:0], wrap64_setPerms_cap[37:0]});
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            wrap64_setPerms_cap = 91'h7_FFFF_FFFF_FFFF_FFFF_FFFF;
            wrap64_setPerms_perms = 31'h7FFF_FFFF;
            #1;

            check_outputs({wrap64_setPerms_cap[90:50], wrap64_setPerms_perms[11:0], wrap64_setPerms_cap[37:0]});
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            wrap64_setPerms_cap = 91'h555_5555_5555_5555_5555_5555;
            wrap64_setPerms_perms = 31'h2AAA_AAAA;
            #1;

            check_outputs({wrap64_setPerms_cap[90:50], wrap64_setPerms_perms[11:0], wrap64_setPerms_cap[37:0]});
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            wrap64_setPerms_cap = 91'h2AA_AAAA_AAAA_AAAA_AAAA_AAAA;
            wrap64_setPerms_perms = 31'h5555_5555;
            #1;

            check_outputs({wrap64_setPerms_cap[90:50], wrap64_setPerms_perms[11:0], wrap64_setPerms_cap[37:0]});
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            wrap64_setPerms_cap = 91'h0;
            wrap64_setPerms_perms = 31'h7FFF_FABC;
            #1;

            check_outputs({41'd0, 12'hABC, 38'd0});
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
        input [90:0] expected_wrap64_setPerms;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_wrap64_setPerms === (expected_wrap64_setPerms ^ wrap64_setPerms ^ expected_wrap64_setPerms)) begin
                $display("PASS");
                $display("  Outputs: wrap64_setPerms=%h",
                         wrap64_setPerms);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wrap64_setPerms=%h",
                         expected_wrap64_setPerms);
                $display("  Got:      wrap64_setPerms=%h",
                         wrap64_setPerms);
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
