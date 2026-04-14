`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] exponent;
    reg [15:0] modulus;
    reg [7:0] plaintext;
    reg reset;
    wire [15:0] ciphertext;
    wire ready;

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
        .ciphertext(ciphertext),
        .ready(ready)
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
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
        end
        endtask
    task wait_until_ready;

        begin
            while (!ready) begin
                @(posedge clk);
            end
        end
        endtask

    task testcase001;

        begin
            $display("\nRunning Testcase 001: P=2, E=3, N=11");
            reset_dut();
            test_num = test_num + 1;
            plaintext = 8'd2;
            exponent = 8'd3;
            modulus = 16'd11;
            wait_until_ready();
            #1;

            check_outputs(16'd8, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: P=5, E=2, N=7");
            reset_dut();
            test_num = test_num + 1;
            plaintext = 8'd5;
            exponent = 8'd2;
            modulus = 16'd7;
            wait_until_ready();
            #1;

            check_outputs(16'd4, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: P=10, E=3, N=33");
            reset_dut();
            test_num = test_num + 1;
            plaintext = 8'd10;
            exponent = 8'd3;
            modulus = 16'd33;
            wait_until_ready();
            #1;

            check_outputs(16'd10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: P=123, E=1, N=257");
            reset_dut();
            test_num = test_num + 1;
            plaintext = 8'd123;
            exponent = 8'd1;
            modulus = 16'd257;
            wait_until_ready();
            #1;

            check_outputs(16'd123, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: P=2, E=10, N=1000");
            reset_dut();
            test_num = test_num + 1;
            plaintext = 8'd2;
            exponent = 8'd10;
            modulus = 16'd1000;
            wait_until_ready();
            #1;

            check_outputs(16'd24, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: P=3, E=4, N=13");
            reset_dut();
            test_num = test_num + 1;
            plaintext = 8'd3;
            exponent = 8'd4;
            modulus = 16'd13;
            wait_until_ready();
            #1;

            check_outputs(16'd3, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: P=15, E=2, N=7");
            reset_dut();
            test_num = test_num + 1;
            plaintext = 8'd15;
            exponent = 8'd2;
            modulus = 16'd7;
            wait_until_ready();
            #1;

            check_outputs(16'd1, 1'b1);
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
        input [15:0] expected_ciphertext;
        input expected_ready;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h, ready=%b",
                         ciphertext, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h, ready=%b",
                         expected_ciphertext, expected_ready);
                $display("  Got:      ciphertext=%h, ready=%b",
                         ciphertext, ready);
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
        $dumpvars(0,clk, exponent, modulus, plaintext, reset, ciphertext, ready);
    end

endmodule
