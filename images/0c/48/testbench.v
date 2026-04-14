`timescale 1ns/1ps

module rsa_encryption_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] plaintext;
    reg [3:0] public_key;
    wire [3:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encryption dut (
        .plaintext(plaintext),
        .public_key(public_key),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = 1;
            plaintext = 4'h0;
            public_key = 4'h0;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            plaintext = 4'hF;
            public_key = 4'h0;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            plaintext = 4'h0;
            public_key = 4'hF;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            plaintext = 4'hA;
            public_key = 4'h5;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            plaintext = 4'h5;
            public_key = 4'h5;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            plaintext = 4'h8;
            public_key = 4'h4;

            #1;


            check_outputs(4'hC);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            plaintext = 4'h7;
            public_key = 4'hE;

            #1;


            check_outputs(4'h9);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            plaintext = 4'h3;
            public_key = 4'h6;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            plaintext = 4'hB;
            public_key = 4'hD;

            #1;


            check_outputs(4'h6);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            plaintext = 4'hF;
            public_key = 4'hF;

            #1;


            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rsa_encryption Testbench");
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
        input [3:0] expected_ciphertext;
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
