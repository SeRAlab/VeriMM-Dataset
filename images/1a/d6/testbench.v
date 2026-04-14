`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] e;
    reg [31:0] n;
    reg [15:0] plaintext;
    wire [31:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .e(e),
        .n(n),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic exponentiation (2^3 mod 11)", test_num);
        plaintext = 16'd2;
        e = 16'd3;
        n = 32'd11;
        #1;

        check_outputs(32'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Modulo reduction (5^3 mod 13)", test_num);
        plaintext = 16'd5;
        e = 16'd3;
        n = 32'd13;
        #1;

        check_outputs(32'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Exponent of 1", test_num);
        plaintext = 16'd123;
        e = 16'd1;
        n = 32'd500;
        #1;

        check_outputs(32'd123);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Base larger than modulo (10^4 mod 7)", test_num);
        plaintext = 16'd10;
        e = 16'd4;
        n = 32'd7;
        #1;

        check_outputs(32'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity base (1^e mod n)", test_num);
        plaintext = 16'd1;
        e = 16'hFFFF;
        n = 32'd3233;
        #1;

        check_outputs(32'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Standard RSA example (65^17 mod 3233)", test_num);
        plaintext = 16'd65;
        e = 16'd17;
        n = 32'd3233;
        #1;

        check_outputs(32'd2790);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Result is exactly modulo (10^2 mod 100)", test_num);
        plaintext = 16'd10;
        e = 16'd2;
        n = 32'd100;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power of 2 (2^10 mod 1000)", test_num);
        plaintext = 16'd2;
        e = 16'd10;
        n = 32'd1000;
        #1;

        check_outputs(32'd24);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero base (0^5 mod 100)", test_num);
        plaintext = 16'd0;
        e = 16'd5;
        n = 32'd100;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mersenne-like prime check (2^5 mod 31)", test_num);
        plaintext = 16'd2;
        e = 16'd5;
        n = 32'd31;
        #1;

        check_outputs(32'd1);
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
        input [31:0] expected_ciphertext;
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
