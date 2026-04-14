`timescale 1ns/1ps

module chacha20_core_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] counter;
    reg [31:0] key;
    reg [31:0] nonce;
    reg [31:0] plaintext;
    wire [31:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_core dut (
        .counter(counter),
        .key(key),
        .nonce(nonce),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Input", test_num);
            key       = 32'h00000000;
            nonce     = 32'h00000000;
            counter   = 32'h00000000;
            plaintext = 32'h00000000;


            #1;



            check_outputs(ciphertext);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Input", test_num);
            key       = 32'hFFFFFFFF;
            nonce     = 32'hFFFFFFFF;
            counter   = 32'hFFFFFFFF;
            plaintext = 32'hFFFFFFFF;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key Sensitivity Check", test_num);
            key       = 32'h12345678;
            nonce     = 32'h00000000;
            counter   = 32'h00000001;
            plaintext = 32'hABCDEFF0;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Counter Increment (Stream Continuity)", test_num);
            key       = 32'h12345678;
            nonce     = 32'h00000000;
            counter   = 32'h00000002;
            plaintext = 32'hABCDEFF0;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Nonce Variation", test_num);
            key       = 32'h12345678;
            nonce     = 32'h98765432;
            counter   = 32'h00000001;
            plaintext = 32'hABCDEFF0;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Bit Pattern", test_num);
            key       = 32'hA5A5A5A5;
            nonce     = 32'h5A5A5A5A;
            counter   = 32'hDEADC0DE;
            plaintext = 32'h00FF00FF;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Plaintext XOR Verification", test_num);


            key       = 32'hCAFEFEED;
            nonce     = 32'h11223344;
            counter   = 32'h00000005;
            plaintext = 32'h00000000;
            #1;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_core Testbench");
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
        input [31:0] expected_ciphertext;
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
