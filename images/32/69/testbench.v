`timescale 1ns/1ps

module RSA_Encryption_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] exponent;
    reg [9:0] modulus;
    reg [9:0] plaintext;
    wire [9:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RSA_Encryption dut (
        .exponent(exponent),
        .modulus(modulus),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Modulus is Zero", test_num);
        plaintext = 10'd42;
        exponent = 10'd3;
        modulus = 10'd0;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Plaintext is Zero", test_num);
        plaintext = 10'd0;
        exponent = 10'd5;
        modulus = 10'd100;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Exponent is Zero (n^0 mod m = 1)", test_num);
        plaintext = 10'd50;
        exponent = 10'd0;
        modulus = 10'd17;
        #1;

        check_outputs(10'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Basic power (2^3 mod 5 = 3)", test_num);
        plaintext = 10'd2;
        exponent = 10'd3;
        modulus = 10'd5;
        #1;

        check_outputs(10'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Identity mapping (n^1 mod m)", test_num);
        plaintext = 10'd123;
        exponent = 10'd1;
        modulus = 10'd500;
        #1;

        check_outputs(10'd123);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Larger power (3^4 mod 10 = 1)", test_num);
        plaintext = 10'd3;
        exponent = 10'd4;
        modulus = 10'd10;
        #1;

        check_outputs(10'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Plaintext greater than modulus (10^2 mod 7 = 2)", test_num);
        plaintext = 10'd10;
        exponent = 10'd2;
        modulus = 10'd7;
        #1;

        check_outputs(10'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Calculation resulting in remainder (7^3 mod 20 = 3)", test_num);
        plaintext = 10'd7;
        exponent = 10'd3;
        modulus = 10'd20;
        #1;

        check_outputs(10'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Modulus 1 (Any number mod 1 = 0)", test_num);
        plaintext = 10'd25;
        exponent = 10'd2;
        modulus = 10'd1;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Near max 10-bit value (10^3 mod 1023 = 1000)", test_num);
        plaintext = 10'd10;
        exponent = 10'd3;
        modulus = 10'd1023;
        #1;

        check_outputs(10'd1000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RSA_Encryption Testbench");
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
