`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] e;
    reg [9:0] plaintext;
    wire [9:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .e(e),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Plaintext=2, e=3 (Result: 8)", test_num);
            plaintext = 10'd2;
            e = 10'd3;
            #1;

            check_outputs(10'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Plaintext=3, e=4 (Result: 81)", test_num);
            plaintext = 10'd3;
            e = 10'd4;
            #1;

            check_outputs(10'd81);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Plaintext=10, e=2 (Result: 100)", test_num);
            plaintext = 10'd10;
            e = 10'd2;
            #1;

            check_outputs(10'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Modulo Boundary 2^10 mod 1024 (Result: 0)", test_num);
            plaintext = 10'd2;
            e = 10'd10;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Plaintext Square mod 1024 (1023^2 Result: 1)", test_num);
            plaintext = 10'd1023;
            e = 10'd2;
            #1;

            check_outputs(10'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Exponent Zero (Result: 1)", test_num);
            plaintext = 10'd55;
            e = 10'd0;
            #1;

            check_outputs(10'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Plaintext Zero (Result: 0)", test_num);
            plaintext = 10'd0;
            e = 10'd5;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Plaintext One (Result: 1)", test_num);
            plaintext = 10'd1;
            e = 10'd999;
            #1;

            check_outputs(10'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Result (5^5 mod 1024 = 3125 mod 1024 Result: 53)", test_num);
            plaintext = 10'd5;
            e = 10'd5;
            #1;

            check_outputs(10'd53);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 7^4 mod 1024 (Result: 353)", test_num);
            plaintext = 10'd7;
            e = 10'd4;
            #1;

            check_outputs(10'd353);
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
