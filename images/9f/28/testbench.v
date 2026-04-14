`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a_vec;
    reg [3:0] enc_vec;
    reg sign;
    wire pp_i;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_vec(a_vec),
        .enc_vec(enc_vec),
        .sign(sign),
        .pp_i(pp_i)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign=0, a_vec=1010, enc_vec=1111", test_num);
            sign = 1'b0;
            a_vec = 4'b1010;
            enc_vec = 4'b1111;



            #1;




            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign=1, a_vec=1010, enc_vec=1111", test_num);
            sign = 1'b1;
            a_vec = 4'b1010;
            enc_vec = 4'b1111;



            #1;




            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zero inputs", test_num);
            sign = 1'b0;
            a_vec = 4'b0000;
            enc_vec = 4'b0000;



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign bit inverting a_vec to zero", test_num);
            sign = 1'b1;
            a_vec = 4'b1111;
            enc_vec = 4'b1111;



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign bit inverting a_vec to non-zero", test_num);
            sign = 1'b1;
            a_vec = 4'b0000;
            enc_vec = 4'b1111;



            #1;




            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: enc_vec masking all bits", test_num);
            sign = 1'b0;
            a_vec = 4'b1111;
            enc_vec = 4'b0000;



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selective masking (sign 0)", test_num);
            sign = 1'b0;
            a_vec = 4'b1010;
            enc_vec = 4'b0101;



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selective masking (sign 1)", test_num);
            sign = 1'b1;
            a_vec = 4'b1010;
            enc_vec = 4'b0101;



            #1;




            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit match", test_num);
            sign = 1'b0;
            a_vec = 4'b0001;
            enc_vec = 4'b0001;



            #1;




            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit mismatch via inversion", test_num);
            sign = 1'b1;
            a_vec = 4'b0001;
            enc_vec = 4'b0001;



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
        input expected_pp_i;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pp_i === (expected_pp_i ^ pp_i ^ expected_pp_i)) begin
                $display("PASS");
                $display("  Outputs: pp_i=%b",
                         pp_i);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pp_i=%b",
                         expected_pp_i);
                $display("  Got:      pp_i=%b",
                         pp_i);
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
