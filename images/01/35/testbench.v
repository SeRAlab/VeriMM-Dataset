`timescale 1ns/1ps

module aes_encrypt_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_encrypt dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FIPS-197 Round 1", test_num);

            plaintext = 128'h193e42eda4c973be8ad80172b45a1143;

            key = 128'ha0fafe1788542cb123a339392a6c7605;

            #1;


            check_outputs(128'ha49c7ff2689f352b6b5be8a3026a6479);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros State and Key", test_num);
            plaintext = 128'h00000000000000000000000000000000;
            key       = 128'h00000000000000000000000000000000;
            #1;

            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FIPS-197 Round 2", test_num);

            plaintext = 128'ha49c7ff2689f352b6b5be8a3026a6479;

            key = 128'hf2c295f27a96b9435935807ac359ad76;

            #1;


            check_outputs(128'h3902dc1925dc116a8409850b1dfb9732);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones State and Zero Key", test_num);
            plaintext = 128'hffffffffffffffffffffffffffffffff;
            key       = 128'h00000000000000000000000000000000;

            #1;


            check_outputs(128'h7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Input with Specific Key", test_num);
            plaintext = 128'h00000000000000000000000000000000;
            key       = 128'hffffffffffffffffffffffffffffffff;

            #1;


            check_outputs(128'h9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_encrypt Testbench");
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
