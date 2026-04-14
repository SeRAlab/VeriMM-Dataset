`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] e;
    reg [63:0] n;
    reg [63:0] plaintext;
    reg reset;
    wire [63:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .clk(clk),
        .e(e),
        .n(n),
        .plaintext(plaintext),
        .reset(reset),
        .ciphertext(ciphertext)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            e = 0;
            n = 0;
            plaintext = 0;
            repeat (5) @(posedge clk);
            reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Small inputs (2^3 mod 11)", test_num);
            plaintext = 64'd2;
            e = 64'd3;
            n = 64'd11;

            repeat (150) @(posedge clk);
            #1;

            check_outputs(64'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Identity exponent (42^1 mod 100)", test_num);
            plaintext = 64'd42;
            e = 64'd1;
            n = 64'd100;
            repeat (150) @(posedge clk);
            #1;

            check_outputs(64'd42);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Base > Modulo (15^2 mod 10)", test_num);
            plaintext = 64'd15;
            e = 64'd2;
            n = 64'd10;
            repeat (150) @(posedge clk);
            #1;

            check_outputs(64'd5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Squaring (7^2 mod 20)", test_num);
            plaintext = 64'd7;
            e = 64'd2;
            n = 64'd20;
            repeat (150) @(posedge clk);
            #1;

            check_outputs(64'd9);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: RSA Primes (3^7 mod 33)", test_num);
            plaintext = 64'd3;
            e = 64'd7;
            n = 64'd33;
            repeat (150) @(posedge clk);
            #1;

            check_outputs(64'd9);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Larger calculation (123^3 mod 500)", test_num);
            plaintext = 64'd123;
            e = 64'd3;
            n = 64'd500;
            repeat (150) @(posedge clk);
            #1;

            check_outputs(64'd367);
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
        input [63:0] expected_ciphertext;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, e, n, plaintext, reset, ciphertext);
    end

endmodule
