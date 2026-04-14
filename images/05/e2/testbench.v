`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] e;
    reg [7:0] n;
    reg [7:0] plaintext;
    wire [7:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .e(e),
        .n(n),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: plaintext=2, e=3, n=11", test_num);
        plaintext = 8'd2;
        e = 8'd3;
        n = 8'd11;
        #1;

        check_outputs(8'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: plaintext=5, e=3, n=13", test_num);
        plaintext = 8'd5;
        e = 8'd3;
        n = 8'd13;
        #1;

        check_outputs(8'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: plaintext=3, e=7, n=33", test_num);
        plaintext = 8'd3;
        e = 8'd7;
        n = 8'd33;
        #1;

        check_outputs(8'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: plaintext=10, e=3, n=33", test_num);
        plaintext = 8'd10;
        e = 8'd3;
        n = 8'd33;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: plaintext=7, e=5, n=17", test_num);
        plaintext = 8'd7;
        e = 8'd5;
        n = 8'd17;
        #1;

        check_outputs(8'd11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: plaintext=1, e=15, n=50", test_num);
        plaintext = 8'd1;
        e = 8'd15;
        n = 8'd50;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: plaintext=0, e=5, n=21", test_num);
        plaintext = 8'd0;
        e = 8'd5;
        n = 8'd21;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: plaintext=12, e=1, n=50", test_num);
        plaintext = 8'd12;
        e = 8'd1;
        n = 8'd50;
        #1;

        check_outputs(8'd12);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rsa_encrypt Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_ciphertext;
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
