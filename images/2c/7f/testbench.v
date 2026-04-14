`timescale 1ns/1ps

module RSA_Encrypt_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] plaintext;
    reg [15:0] public_key;
    wire [15:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RSA_Encrypt dut (
        .plaintext(plaintext),
        .public_key(public_key),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity Power (e=1)", test_num);
            plaintext = 16'd1234;
            public_key = 16'd1;
            #1;

            check_outputs(16'd1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Plaintext", test_num);
            plaintext = 16'd0;
            public_key = 16'd17;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unity Plaintext", test_num);
            plaintext = 16'd1;
            public_key = 16'hFFFF;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Cubing (5^3)", test_num);
            plaintext = 16'd5;
            public_key = 16'd3;
            #1;

            check_outputs(16'd125);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Power (10^4)", test_num);
            plaintext = 16'd10;
            public_key = 16'd4;
            #1;

            check_outputs(16'd10000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Modulo Wrap (257^2)", test_num);
            plaintext = 16'd257;
            public_key = 16'd2;
            #1;

            check_outputs(16'd512);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Larger Power (10^5)", test_num);
            plaintext = 16'd10;
            public_key = 16'd5;
            #1;

            check_outputs(16'h869F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Power (5^17)", test_num);
            plaintext = 16'd5;
            public_key = 16'd17;
            #1;

            check_outputs(16'h8CBB);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Plaintext Identity", test_num);
            plaintext = 16'hFFFF;
            public_key = 16'd1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RSA_Encrypt Testbench");
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
