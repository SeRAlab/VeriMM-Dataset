`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg aon_io_bootrom;
    reg aon_io_jtagpwd;
    reg aon_io_moff_corerst;
    reg test_iso_override;
    reg test_mode;
    wire aon_iso;
    wire jtagpwd_iso;
    wire [31:0] pc_rtvec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aon_io_bootrom(aon_io_bootrom),
        .aon_io_jtagpwd(aon_io_jtagpwd),
        .aon_io_moff_corerst(aon_io_moff_corerst),
        .test_iso_override(test_iso_override),
        .test_mode(test_mode),
        .aon_iso(aon_iso),
        .jtagpwd_iso(jtagpwd_iso),
        .pc_rtvec(pc_rtvec)
    );
    task testcase001;

        begin
            test_num = 1;
            test_mode = 0;
            test_iso_override = 0;
            aon_io_moff_corerst = 1;
            aon_io_jtagpwd = 1;
            aon_io_bootrom = 1;
            #1;

            check_outputs(1'b1, 1'b1, ADDR_BOOTROM);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            test_mode = 0;
            test_iso_override = 1;
            aon_io_moff_corerst = 0;
            aon_io_jtagpwd = 0;
            aon_io_bootrom = 0;
            #1;

            check_outputs(1'b0, 1'b0, ADDR_DEFAULT);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            test_mode = 1;
            test_iso_override = 1;
            aon_io_moff_corerst = 0;
            aon_io_jtagpwd = 0;
            aon_io_bootrom = 1;
            #1;

            check_outputs(1'b1, 1'b1, ADDR_BOOTROM);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            test_mode = 1;
            test_iso_override = 0;
            aon_io_moff_corerst = 1;
            aon_io_jtagpwd = 1;
            aon_io_bootrom = 0;
            #1;

            check_outputs(1'b0, 1'b0, ADDR_DEFAULT);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            test_mode = 0;
            test_iso_override = 0;
            aon_io_moff_corerst = 1;
            aon_io_jtagpwd = 0;
            aon_io_bootrom = 1;
            #1;

            check_outputs(1'b1, 1'b0, ADDR_BOOTROM);
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
        input expected_aon_iso;
        input expected_jtagpwd_iso;
        input [31:0] expected_pc_rtvec;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aon_iso === (expected_aon_iso ^ aon_iso ^ expected_aon_iso) &&
                expected_jtagpwd_iso === (expected_jtagpwd_iso ^ jtagpwd_iso ^ expected_jtagpwd_iso) &&
                expected_pc_rtvec === (expected_pc_rtvec ^ pc_rtvec ^ expected_pc_rtvec)) begin
                $display("PASS");
                $display("  Outputs: aon_iso=%b, jtagpwd_iso=%b, pc_rtvec=%h",
                         aon_iso, jtagpwd_iso, pc_rtvec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aon_iso=%b, jtagpwd_iso=%b, pc_rtvec=%h",
                         expected_aon_iso, expected_jtagpwd_iso, expected_pc_rtvec);
                $display("  Got:      aon_iso=%b, jtagpwd_iso=%b, pc_rtvec=%h",
                         aon_iso, jtagpwd_iso, pc_rtvec);
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
