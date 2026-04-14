`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg arst_l;
    reg mem_write_disable;
    reg se;
    reg sehold;
    wire arst_l_buf;
    wire mem_write_disable_buf;
    wire se_buf;
    wire sehold_buf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arst_l(arst_l),
        .mem_write_disable(mem_write_disable),
        .se(se),
        .sehold(sehold),
        .arst_l_buf(arst_l_buf),
        .mem_write_disable_buf(mem_write_disable_buf),
        .se_buf(se_buf),
        .sehold_buf(sehold_buf)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: All inputs low", test_num);
            mem_write_disable = 0;
            sehold = 0;
            se = 0;
            arst_l = 0;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: All inputs high", test_num);
            mem_write_disable = 1;
            sehold = 1;
            se = 1;
            arst_l = 1;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Only mem_write_disable active", test_num);
            mem_write_disable = 1;
            sehold = 0;
            se = 0;
            arst_l = 0;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Only sehold active", test_num);
            mem_write_disable = 0;
            sehold = 1;
            se = 0;
            arst_l = 0;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Only se active", test_num);
            mem_write_disable = 0;
            sehold = 0;
            se = 1;
            arst_l = 0;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Only arst_l active", test_num);
            mem_write_disable = 0;
            sehold = 0;
            se = 0;
            arst_l = 1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Checkerboard pattern 1010", test_num);
            mem_write_disable = 1;
            sehold = 0;
            se = 1;
            arst_l = 0;
            #1;

            check_outputs(0, 1, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Checkerboard pattern 0101", test_num);
            mem_write_disable = 0;
            sehold = 1;
            se = 0;
            arst_l = 1;
            #1;

            check_outputs(1, 0, 0, 1);
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
        input expected_arst_l_buf;
        input expected_mem_write_disable_buf;
        input expected_se_buf;
        input expected_sehold_buf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_arst_l_buf === (expected_arst_l_buf ^ arst_l_buf ^ expected_arst_l_buf) &&
                expected_mem_write_disable_buf === (expected_mem_write_disable_buf ^ mem_write_disable_buf ^ expected_mem_write_disable_buf) &&
                expected_se_buf === (expected_se_buf ^ se_buf ^ expected_se_buf) &&
                expected_sehold_buf === (expected_sehold_buf ^ sehold_buf ^ expected_sehold_buf)) begin
                $display("PASS");
                $display("  Outputs: arst_l_buf=%b, mem_write_disable_buf=%b, se_buf=%b, sehold_buf=%b",
                         arst_l_buf, mem_write_disable_buf, se_buf, sehold_buf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: arst_l_buf=%b, mem_write_disable_buf=%b, se_buf=%b, sehold_buf=%b",
                         expected_arst_l_buf, expected_mem_write_disable_buf, expected_se_buf, expected_sehold_buf);
                $display("  Got:      arst_l_buf=%b, mem_write_disable_buf=%b, se_buf=%b, sehold_buf=%b",
                         arst_l_buf, mem_write_disable_buf, se_buf, sehold_buf);
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
