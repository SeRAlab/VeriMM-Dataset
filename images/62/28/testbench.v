`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg SVSTOP;
    reg rst_res_n;
    wire A;
    wire Out0;
    wire Out1;
    wire peri_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SVSTOP(SVSTOP),
        .rst_res_n(rst_res_n),
        .A(A),
        .Out0(Out0),
        .Out1(Out1),
        .peri_o(peri_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase001: rst_res_n=0, SVSTOP=0");


            rst_res_n = 1'b0;
            SVSTOP = 1'b0;

            #10;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase002: rst_res_n=1, SVSTOP=0");


            rst_res_n = 1'b0;
            #5;


            rst_res_n = 1'b1;
            SVSTOP = 1'b0;

            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase003: rst_res_n=0, SVSTOP=1");


            rst_res_n = 1'b0;
            SVSTOP = 1'b1;

            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase004: rst_res_n=1, SVSTOP=1");


            rst_res_n = 1'b0;
            #5;


            rst_res_n = 1'b1;
            SVSTOP = 1'b1;

            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
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
        input expected_A;
        input expected_Out0;
        input expected_Out1;
        input expected_peri_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_Out0 === (expected_Out0 ^ Out0 ^ expected_Out0) &&
                expected_Out1 === (expected_Out1 ^ Out1 ^ expected_Out1) &&
                expected_peri_o === (expected_peri_o ^ peri_o ^ expected_peri_o)) begin
                $display("PASS");
                $display("  Outputs: A=%b, Out0=%b, Out1=%b, peri_o=%b",
                         A, Out0, Out1, peri_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%b, Out0=%b, Out1=%b, peri_o=%b",
                         expected_A, expected_Out0, expected_Out1, expected_peri_o);
                $display("  Got:      A=%b, Out0=%b, Out1=%b, peri_o=%b",
                         A, Out0, Out1, peri_o);
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
