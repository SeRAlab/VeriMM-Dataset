`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] exponent;
    reg [127:0] modulus;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .clk(clk),
        .exponent(exponent),
        .modulus(modulus),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            plaintext <= 0;
            exponent <= 0;
            modulus <= 1;
            test_num = test_num + 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Test Case 001: P^1 mod M");
            plaintext = 128'hA1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4;
            exponent  = 128'h1;
            modulus   = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(128'hA1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Test Case 002: Small powers (5^3 mod 13)");
            plaintext = 128'd5;
            exponent  = 128'd3;
            modulus   = 128'd13;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(128'd8);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Test Case 003: 2^10 mod 1000");
            plaintext = 128'd2;
            exponent  = 128'd10;
            modulus   = 128'd1000;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(128'd24);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Test Case 004: Zero plaintext");
            plaintext = 128'd0;
            exponent  = 128'hDEADBEEF;
            modulus   = 128'hFFFFFFFF;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(128'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Test Case 005: Plaintext equals Modulus");
            plaintext = 128'hABCDEF;
            exponent  = 128'd2;
            modulus   = 128'hABCDEF;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(128'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Test Case 006: 7^2 mod 50");
            plaintext = 128'd7;
            exponent  = 128'd2;
            modulus   = 128'd50;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(128'd49);
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
        input [127:0] expected_ciphertext;
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
        $dumpvars(0,clk, exponent, modulus, plaintext, ciphertext);
    end

endmodule
