`timescale 1ns/1ps

module aes_256_encryption_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] key;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_256_encryption dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        key = 256'h0000000000000000000000000000000000000000000000000000000000000000;
        plaintext = 128'h00000000000000000000000000000000;
        #1;

        check_outputs(128'hdc95c078a2408989ad48a21492842087);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: NIST Standard Sequence", test_num);
        key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
        plaintext = 128'h00112233445566778899aabbccddeeff;
        #1;

        check_outputs(128'h8ea2b7ca516745bfeafc49904b496089);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: NIST SP 800-38A Appendix C Vectors", test_num);
        key = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;
        plaintext = 128'h6bc1bee22e409f96e93d7e117393172a;
        #1;

        check_outputs(128'hf3eed1bdb5d2a03c0619803062257823);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        key = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        plaintext = 128'hffffffffffffffffffffffffffffffff;
        #1;

        check_outputs(128'he921d782167d49826d9e0783141f1225);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mixed Pattern", test_num);
        key = 256'h5555555555555555555555555555555555555555555555555555555555555555;
        plaintext = 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
        #1;

        check_outputs(128'h0a8308871037890989f66085a210757d);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_256_encryption Testbench");
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
