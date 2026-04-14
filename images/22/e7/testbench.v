`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] exponent;
    reg [4:0] modulus;
    reg [4:0] plaintext;
    reg rst;
    wire [4:0] ciphertext;

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
        .rst(rst),
        .ciphertext(ciphertext)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            exponent = 0;
            modulus = 0;
            plaintext = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            plaintext = 5'd2;
            exponent = 3'd3;
            modulus = 5'd11;

            repeat(10) @(posedge clk);
            $display("Test Case 001: 2^3 mod 11");
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            plaintext = 5'd3;
            exponent = 3'd3;
            modulus = 5'd10;
            repeat(10) @(posedge clk);
            $display("Test Case 002: 3^3 mod 10");
            #1;

            check_outputs(5'd7);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            plaintext = 5'd1;
            exponent = 3'd5;
            modulus = 5'd7;
            repeat(10) @(posedge clk);
            $display("Test Case 003: 1^5 mod 7");
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            plaintext = 5'd10;
            exponent = 3'd1;
            modulus = 5'd17;
            repeat(10) @(posedge clk);
            $display("Test Case 004: 10^1 mod 17");
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            plaintext = 5'd4;
            exponent = 3'd2;
            modulus = 5'd15;
            repeat(10) @(posedge clk);
            $display("Test Case 005: 4^2 mod 15");
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            plaintext = 5'd7;
            exponent = 3'd3;
            modulus = 5'd19;
            repeat(10) @(posedge clk);
            $display("Test Case 006: 7^3 mod 19");
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            plaintext = 5'd0;
            exponent = 3'd3;
            modulus = 5'd11;
            repeat(10) @(posedge clk);
            $display("Test Case 007: 0^3 mod 11");
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            plaintext = 5'd5;
            exponent = 3'd3;
            modulus = 5'd13;
            repeat(10) @(posedge clk);
            $display("Test Case 008: 5^3 mod 13");
            #1;

            check_outputs(5'd8);
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
        input [4:0] expected_ciphertext;
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
        $dumpvars(0,clk, exponent, modulus, plaintext, rst, ciphertext);
    end

endmodule
