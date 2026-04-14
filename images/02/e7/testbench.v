`timescale 1ns/1ps

module aes_256_encrypt_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] key;
    reg [255:0] plaintext;
    wire [255:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_256_encrypt dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros Input", test_num);

            plaintext = 256'h0000000000000000000000000000000000000000000000000000000000000000;
            key       = 256'h0000000000000000000000000000000000000000000000000000000000000000;



            #1;




            check_outputs(256'h8ea2b7ca516745bf0fb40143896464f69741e458742d75a6c085006b5327242e);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones Input", test_num);
            plaintext = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            key       = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

            #1;


            check_outputs(256'h77726715697479630d061c14041e170a77726715697479630d061c14041e170a);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Incremental Pattern", test_num);

            plaintext = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

            key       = 256'h1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;

            #1;


            check_outputs(256'h7098e79c2998f4e24747719601018596656512349812984512457812ab451234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checkerboard Pattern", test_num);
            plaintext = 256'h55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA;
            key       = 256'hAA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55;

            #1;


            check_outputs(256'h454512128989abab454512128989abab454512128989abab454512128989abab);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: NIST-style Vector (Modified for 256b block)", test_num);

            plaintext = 256'h014730bcd2b3cb47acc035658e4695e920612c62ce790387588e36746813e3bc;
            key       = 256'h2b7e151628aed2a6abf7158809cf4f3c762e7160f38b4da56a784d904519060f;

            #1;


            check_outputs(256'hb2833075240210f6079c6753c13567b14d3c347f988e010c22359002134598fd);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_256_encrypt Testbench");
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
        input [255:0] expected_ciphertext;
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
