`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg gen_flag;
    reg [7:0] hash_func;
    reg [7:0] key;
    reg [7:0] msg;
    wire auth_flag;
    wire [7:0] hmac;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .gen_flag(gen_flag),
        .hash_func(hash_func),
        .key(key),
        .msg(msg),
        .auth_flag(auth_flag),
        .hmac(hmac)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SHA-256 Generation Mode", test_num);
            msg = 8'h12;
            key = 8'h34;
            hash_func = 8'h01;
            gen_flag = 1'b1;

            #1;


            check_outputs(1'b1, 8'h27);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SHA-512 Generation Mode", test_num);
            msg = 8'h55;
            key = 8'hAA;
            hash_func = 8'h02;
            gen_flag = 1'b1;

            #1;


            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MD5 Generation Mode", test_num);
            msg = 8'h0F;
            key = 8'hF0;
            hash_func = 8'h03;
            gen_flag = 1'b1;

            #1;


            check_outputs(1'b1, 8'hFC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SHA-256 Verification Mode", test_num);
            msg = 8'h12;
            key = 8'h34;
            hash_func = 8'h01;
            gen_flag = 1'b0;

            #1;


            check_outputs(1'b1, 8'h27);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary All Zeros", test_num);
            msg = 8'h00;
            key = 8'h00;
            hash_func = 8'h01;
            gen_flag = 1'b1;
            #1;

            check_outputs(1'b1, 8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary All Ones", test_num);
            msg = 8'hFF;
            key = 8'hFF;
            hash_func = 8'h02;
            gen_flag = 1'b1;
            #1;

            check_outputs(1'b1, 8'h02);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MD5 Verification Mode", test_num);
            msg = 8'hA5;
            key = 8'h5A;
            hash_func = 8'h03;
            gen_flag = 1'b0;

            #1;


            check_outputs(1'b1, 8'hFC);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dynamic Hash Function Switching", test_num);
            msg = 8'hCC;
            key = 8'h33;
            gen_flag = 1'b1;


            hash_func = 8'h03;
            #1;

            hash_func = 8'h02;


            #1;



            check_outputs(1'b1, 8'hFD);
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
        input expected_auth_flag;
        input [7:0] expected_hmac;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_auth_flag === (expected_auth_flag ^ auth_flag ^ expected_auth_flag) &&
                expected_hmac === (expected_hmac ^ hmac ^ expected_hmac)) begin
                $display("PASS");
                $display("  Outputs: auth_flag=%b, hmac=%h",
                         auth_flag, hmac);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: auth_flag=%b, hmac=%h",
                         expected_auth_flag, expected_hmac);
                $display("  Got:      auth_flag=%b, hmac=%h",
                         auth_flag, hmac);
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
