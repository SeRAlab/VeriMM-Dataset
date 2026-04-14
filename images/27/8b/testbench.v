`timescale 1ns/1ps

module aes_add_round_key_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] plaintext;
    reg [127:0] round_key;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_add_round_key dut (
        .plaintext(plaintext),
        .round_key(round_key),
        .ciphertext(ciphertext)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        plaintext = 128'h0;
        round_key = 128'h0;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Key with All Ones", test_num);
        plaintext = 128'h0;
        round_key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Plaintext with All Ones", test_num);
        plaintext = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        round_key = 128'h0;
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Complementary XOR", test_num);
        plaintext = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        round_key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Standard AES Vector (FIPS-197 Example)", test_num);


        plaintext = 128'h3243f6a8885a308d313198a2e0370734;
        round_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;

        #1;


        check_outputs(128'h193de3bea0f4e22b9ac68d2ae9f84808);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits Pattern", test_num);
        plaintext = 128'h55555555555555555555555555555555;
        round_key = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit Difference", test_num);
        plaintext = 128'h00000000000000000000000000000001;
        round_key = 128'h00000000000000000000000000000001;
        #1;

        check_outputs(128'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_add_round_key Testbench");
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
