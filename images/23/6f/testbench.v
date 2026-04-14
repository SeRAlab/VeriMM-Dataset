`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] exponent;
    reg [11:0] modulus;
    reg [7:0] plaintext;
    reg rst;
    wire [11:0] ciphertext;

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
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Simple Identity (e=1)", test_num);
            plaintext = 8'd5;
            exponent = 12'd1;
            modulus = 12'd100;
            #500;
            #1;

            check_outputs(12'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: 2^7 mod 143", test_num);
            plaintext = 8'd2;
            exponent = 12'd7;
            modulus = 12'd143;
            #500;
            #1;

            check_outputs(12'd128);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Exponentiation wrap (10^3 mod 33)", test_num);
            plaintext = 8'd10;
            exponent = 12'd3;
            modulus = 12'd33;
            #500;
            #1;

            check_outputs(12'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: 15^3 mod 253", test_num);
            plaintext = 8'd15;
            exponent = 12'd3;
            modulus = 12'd253;
            #500;
            #1;

            check_outputs(12'd86);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: 3^11 mod 100", test_num);
            plaintext = 8'd3;
            exponent = 12'd11;
            modulus = 12'd100;
            #500;
            #1;

            check_outputs(12'd47);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Zero plaintext", test_num);
            plaintext = 8'd0;
            exponent = 12'd5;
            modulus = 12'd101;
            #500;
            #1;

            check_outputs(12'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test %0d: One plaintext", test_num);
            plaintext = 8'd1;
            exponent = 12'd99;
            modulus = 12'd500;
            #500;
            #1;

            check_outputs(12'd1);
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
        input [11:0] expected_ciphertext;
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
