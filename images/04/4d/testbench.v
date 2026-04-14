`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] exponent;
    reg [127:0] modulus;
    reg [127:0] plaintext;
    reg reset;
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
            exponent = 0;
            modulus = 0;
            plaintext = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Small power (2^3 mod 11)", test_num);
            plaintext = 128'd2;
            exponent = 128'd3;
            modulus = 128'd11;


            #5000;
            #1;

            check_outputs(128'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Power of 7 mod 100", test_num);
            plaintext = 128'd7;
            exponent = 128'd3;
            modulus = 128'd100;
            #5000;
            #1;

            check_outputs(128'd43);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: 3^10 mod 1000", test_num);
            plaintext = 128'd3;
            exponent = 128'd10;
            modulus = 128'd1000;
            #5000;
            #1;

            check_outputs(128'd49);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Identity Exponent (e=1)", test_num);
            plaintext = 128'hDEADBEEF;
            exponent = 128'd1;
            modulus = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            #5000;
            #1;

            check_outputs(128'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Plaintext = 1", test_num);
            plaintext = 128'd1;
            exponent = 128'h12345678;
            modulus = 128'hFFFF;
            #5000;
            #1;

            check_outputs(128'd1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: 3^4 mod 5", test_num);
            plaintext = 128'd3;
            exponent = 128'd4;
            modulus = 128'd5;
            #5000;
            #1;

            check_outputs(128'd1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: 10^2 mod 13", test_num);
            plaintext = 128'd10;
            exponent = 128'd2;
            modulus = 128'd13;
            #5000;
            #1;

            check_outputs(128'd9);
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
        $dumpvars(0,clk, exponent, modulus, plaintext, reset, ciphertext);
    end

endmodule
