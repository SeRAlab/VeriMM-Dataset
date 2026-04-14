`timescale 1ns/1ps

module rsa_encryption_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] plaintext;
    reg [15:0] public_key;
    wire [15:0] ciphertext;

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
            test_num = test_num + 1;
            $display("Test Case %0d: Plaintext=123, Key=17", test_num);
            plaintext = 16'd123;
            public_key = 16'd17;
            #1;

            check_outputs(16'd855);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Plaintext=65, Key=17", test_num);
            plaintext = 16'd65;
            public_key = 16'd17;
            #1;

            check_outputs(16'd2790);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Plaintext=2, Key=7", test_num);
            plaintext = 16'd2;
            public_key = 16'd7;
            #1;

            check_outputs(16'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Plaintext=1, Key=65535", test_num);
            plaintext = 16'd1;
            public_key = 16'hFFFF;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Plaintext=0, Key=17", test_num);
            plaintext = 16'd0;
            public_key = 16'd17;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Plaintext=3234 (P > n), Key=17", test_num);
            plaintext = 16'd3234;
            public_key = 16'd17;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Plaintext=500, Key=1", test_num);
            plaintext = 16'd500;
            public_key = 16'd1;
            #1;

            check_outputs(16'd500);
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
        input [15:0] expected_ciphertext;
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
