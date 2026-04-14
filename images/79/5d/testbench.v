`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg din2_din1_denorm_hi;
    reg din2_din1_denorm_lo;
    reg din2_din1_denorm_mid;
    reg din2_din1_nz_hi;
    reg din2_din1_nz_lo;
    reg din2_din1_nz_mid;
    wire din2_din1_denorm;
    wire din2_din1_nz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din2_din1_denorm_hi(din2_din1_denorm_hi),
        .din2_din1_denorm_lo(din2_din1_denorm_lo),
        .din2_din1_denorm_mid(din2_din1_denorm_mid),
        .din2_din1_nz_hi(din2_din1_nz_hi),
        .din2_din1_nz_lo(din2_din1_nz_lo),
        .din2_din1_nz_mid(din2_din1_nz_mid),
        .din2_din1_denorm(din2_din1_denorm),
        .din2_din1_nz(din2_din1_nz)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs zero", test_num);
            din2_din1_nz_hi = 0;
            din2_din1_nz_mid = 0;
            din2_din1_nz_lo = 0;
            din2_din1_denorm_hi = 0;
            din2_din1_denorm_mid = 0;
            din2_din1_denorm_lo = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: High non-zero segment set", test_num);
            din2_din1_nz_hi = 1;
            din2_din1_nz_mid = 0;
            din2_din1_nz_lo = 0;
            din2_din1_denorm_hi = 0;
            din2_din1_denorm_mid = 0;
            din2_din1_denorm_lo = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Mid non-zero segment set", test_num);
            din2_din1_nz_hi = 0;
            din2_din1_nz_mid = 1;
            din2_din1_nz_lo = 0;
            din2_din1_denorm_hi = 0;
            din2_din1_denorm_mid = 0;
            din2_din1_denorm_lo = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Low non-zero segment set", test_num);
            din2_din1_nz_hi = 0;
            din2_din1_nz_mid = 0;
            din2_din1_nz_lo = 1;
            din2_din1_denorm_hi = 0;
            din2_din1_denorm_mid = 0;
            din2_din1_denorm_lo = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: High denorm segment set", test_num);
            din2_din1_nz_hi = 0;
            din2_din1_nz_mid = 0;
            din2_din1_nz_lo = 0;
            din2_din1_denorm_hi = 1;
            din2_din1_denorm_mid = 0;
            din2_din1_denorm_lo = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mid denorm segment set", test_num);
            din2_din1_nz_hi = 0;
            din2_din1_nz_mid = 0;
            din2_din1_nz_lo = 0;
            din2_din1_denorm_hi = 0;
            din2_din1_denorm_mid = 1;
            din2_din1_denorm_lo = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Low denorm segment set", test_num);
            din2_din1_nz_hi = 0;
            din2_din1_nz_mid = 0;
            din2_din1_nz_lo = 0;
            din2_din1_denorm_hi = 0;
            din2_din1_denorm_mid = 0;
            din2_din1_denorm_lo = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: All segments non-zero and denorm", test_num);
            din2_din1_nz_hi = 1;
            din2_din1_nz_mid = 1;
            din2_din1_nz_lo = 1;
            din2_din1_denorm_hi = 1;
            din2_din1_denorm_mid = 1;
            din2_din1_denorm_lo = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Mixed status - Mid NZ and Lo Denorm", test_num);
            din2_din1_nz_hi = 0;
            din2_din1_nz_mid = 1;
            din2_din1_nz_lo = 0;
            din2_din1_denorm_hi = 0;
            din2_din1_denorm_mid = 0;
            din2_din1_denorm_lo = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Multi NZ segments set", test_num);
            din2_din1_nz_hi = 1;
            din2_din1_nz_mid = 0;
            din2_din1_nz_lo = 1;
            din2_din1_denorm_hi = 0;
            din2_din1_denorm_mid = 0;
            din2_din1_denorm_lo = 0;
            #1;

            check_outputs(0, 1);
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
        input expected_din2_din1_denorm;
        input expected_din2_din1_nz;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_din2_din1_denorm === (expected_din2_din1_denorm ^ din2_din1_denorm ^ expected_din2_din1_denorm) &&
                expected_din2_din1_nz === (expected_din2_din1_nz ^ din2_din1_nz ^ expected_din2_din1_nz)) begin
                $display("PASS");
                $display("  Outputs: din2_din1_denorm=%b, din2_din1_nz=%b",
                         din2_din1_denorm, din2_din1_nz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: din2_din1_denorm=%b, din2_din1_nz=%b",
                         expected_din2_din1_denorm, expected_din2_din1_nz);
                $display("  Got:      din2_din1_denorm=%b, din2_din1_nz=%b",
                         din2_din1_denorm, din2_din1_nz);
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
