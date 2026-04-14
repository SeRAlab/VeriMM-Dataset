`timescale 1ns/1ps

module AES_128_one_round_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AES_128_one_round dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: All Zeros", test_num);
        plaintext = 128'h00000000000000000000000000000000;
        key       = 128'h00000000000000000000000000000000;
        #1;

        check_outputs(128'h63636363636363636363636363636363);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: NIST Appendix B Round 1", test_num);
        plaintext = 128'h00112233445566778899aabbccddeeff;
        key       = 128'h000102030405060708090a0b0c0d0e0f;

        #1;


        check_outputs(128'h5f72641557f5bc92f7be3b291db9f91a);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: NIST Example 1 Round 1", test_num);
        plaintext = 128'h3243f6a8885a308d313198a2e0370734;
        key       = 128'h2b7e151628aed2a6abf7158809cf4f3c;

        #1;


        check_outputs(128'h046681e5e0cb199a48f8d671d6ef0947);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: All Ones Plaintext", test_num);
        plaintext = 128'hffffffffffffffffffffffffffffffff;
        key       = 128'h00000000000000000000000000000000;
        #1;

        check_outputs(128'h16161616161616161616161616161616);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Mixed Values", test_num);
        plaintext = 128'h000102030405060708090a0b0c0d0e0f;
        key       = 128'hffffffffffffffffffffffffffffffff;




        #1;





        check_outputs(128'hd7803e7208d052a3922718e003180e22);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AES_128_one_round Testbench");
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
