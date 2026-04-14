`timescale 1ns/1ps

module rsa_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] exponent;
    reg [15:0] modulus;
    reg [15:0] plaintext;
    reg reset;
    wire [31:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encryption dut (
        .clk(clk),
        .exponent(exponent),
        .modulus(modulus),
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
            plaintext = 0;
            exponent = 0;
            modulus = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 16'd2;
            exponent = 16'd3;
            modulus = 16'd11;
            repeat(40) @(posedge clk);
            $write("Test Case %0d: (2^3 mod 11) - ", test_num);
            #1;

            check_outputs(32'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 16'd123;
            exponent = 16'd1;
            modulus = 16'd200;
            repeat(40) @(posedge clk);
            $write("Test Case %0d: (123^1 mod 200) - ", test_num);
            #1;

            check_outputs(32'd123);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 16'd1;
            exponent = 16'hFFFF;
            modulus = 16'd500;
            repeat(40) @(posedge clk);
            $write("Test Case %0d: (1^65535 mod 500) - ", test_num);
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 16'd5;
            exponent = 16'd3;
            modulus = 16'd13;
            repeat(40) @(posedge clk);
            $write("Test Case %0d: (5^3 mod 13) - ", test_num);
            #1;

            check_outputs(32'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 16'd10;
            exponent = 16'd4;
            modulus = 16'd33;
            repeat(40) @(posedge clk);
            $write("Test Case %0d: (10^4 mod 33) - ", test_num);
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 16'd15;
            exponent = 16'd2;
            modulus = 16'd7;
            repeat(40) @(posedge clk);
            $write("Test Case %0d: (15^2 mod 7) - ", test_num);
            #1;

            check_outputs(32'd1);
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
        $dumpvars(0,clk, exponent, modulus, plaintext, reset, ciphertext);
    end

endmodule
