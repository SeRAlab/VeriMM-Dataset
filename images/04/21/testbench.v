`timescale 1ns/1ps

module AES_128_Encrypt_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AES_128_Encrypt dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: NIST Standard Example 1 (FIPS 197 Appendix B)", test_num);
            key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            plaintext = 128'h3243f6a8885a308d313198a2e0370734;

            #1;


            check_outputs(128'h3925841d02dc09fbdc118597196a0b32);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Key and Plaintext)", test_num);
            key = 128'h00000000000000000000000000000000;
            plaintext = 128'h00000000000000000000000000000000;

            #1;


            check_outputs(128'h66e94bd4ef8a2c3b884cfa59ca342b2e);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incremental Pattern", test_num);
            key = 128'h000102030405060708090a0b0c0d0e0f;
            plaintext = 128'h00112233445566778899aabbccddeeff;

            #1;


            check_outputs(128'h69c4e0d86a7b0430d8cdb78070b4c55a);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Key with All Zeros Plaintext", test_num);
            key = 128'hffffffffffffffffffffffffffffffff;
            plaintext = 128'h00000000000000000000000000000000;
            #1;

            check_outputs(128'ha1f6258c877d5fcd8964484538bfc92c);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: NIST SP 800-38A Example", test_num);
            key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            plaintext = 128'h6bc1bee22e409f96e93d7e117393172a;
            #1;

            check_outputs(128'h3ad77bb40d7a3660a89ecaf32466ef97);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AES_128_Encrypt Testbench");
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
        input [127:0] expected_ciphertext;
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
