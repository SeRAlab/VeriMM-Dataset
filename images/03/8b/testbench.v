`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: NIST Standard Vector - Round 1", test_num);

            plaintext = 128'h193de3bea0f4e22b9ac68d2ae9f84808;

            key       = 128'ha0fafe1788542cb123a339392a6c7605;





            #1;






            check_outputs(128'ha49bcff2689f352b6b5bef88401358f7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Test", test_num);
            plaintext = 128'h00000000000000000000000000000000;
            key       = 128'h00000000000000000000000000000000;





            #1;






            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incremental Byte Values", test_num);
            plaintext = 128'h00112233445566778899aabbccddeeff;
            key       = 128'h000102030405060708090a0b0c0d0e0f;





            #1;






            check_outputs(128'he68895f44c0b63376e696ac9353fe875);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Bit Density (All FFs)", test_num);
            plaintext = 128'hffffffffffffffffffffffffffffffff;
            key       = 128'hffffffffffffffffffffffffffffffff;





            #1;






            check_outputs(128'he9e9e9e9e9e9e9e9e9e9e9e9e9e9e9e9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_round Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
