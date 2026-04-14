`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] key;
    reg [9:0] plaintext;
    wire [9:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity check (e=1)", test_num);
            plaintext = 10'd123;
            key = 8'd1;
            #1;

            check_outputs(10'd123);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero plaintext check", test_num);
            plaintext = 10'd0;
            key = 8'd55;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unit plaintext check", test_num);
            plaintext = 10'd1;
            key = 8'd255;
            #1;

            check_outputs(10'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of 2 (No wrap)", test_num);
            plaintext = 10'd2;
            key = 8'd8;
            #1;

            check_outputs(10'd256);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small modulo wrap (32^2 mod 1021)", test_num);
            plaintext = 10'd32;
            key = 8'd2;
            #1;

            check_outputs(10'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Larger exponent wrap (11^3 mod 1021)", test_num);
            plaintext = 10'd11;
            key = 8'd3;
            #1;

            check_outputs(10'd310);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max plaintext wrap (1023^2 mod 1021)", test_num);
            plaintext = 10'd1023;
            key = 8'd2;
            #1;

            check_outputs(10'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rsa_encrypt Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [9:0] expected_ciphertext;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h",
                         ciphertext);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h",
                         expected_ciphertext);
                $display("  Got:      ciphertext=%h",
                         ciphertext);
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
