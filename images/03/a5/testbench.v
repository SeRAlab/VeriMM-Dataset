`timescale 1ns/1ps

module rsa_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] exponent;
    reg [15:0] modulus;
    reg [15:0] plaintext;
    reg reset;
    wire [15:0] ciphertext;
    wire done;

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
        .ciphertext(ciphertext),
        .done(done)
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
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Small base and exponent (3^3 mod 10)", test_num);
            plaintext = 16'h0003;
            exponent = 16'h0003;
            modulus = 16'h000A;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'h0007, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Exponent of 1 (42^1 mod 100)", test_num);
            plaintext = 16'h002A;
            exponent = 16'h0001;
            modulus = 16'h0064;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'h002A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Base of 1 (1^17 mod 3233)", test_num);
            plaintext = 16'h0001;
            exponent = 16'h0011;
            modulus = 16'h0CA1;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'h0001, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: RSA calculation (7^3 mod 33)", test_num);
            plaintext = 16'h0007;
            exponent = 16'h0003;
            modulus = 16'h0021;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'h000D, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Moderate numbers (123^13 mod 491)", test_num);
            plaintext = 16'd123;
            exponent = 16'd13;
            modulus = 16'd491;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd361, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Typical RSA keys (15^17 mod 3233)", test_num);
            plaintext = 16'd15;
            exponent = 16'd17;
            modulus = 16'd3233;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd3031, 1'b1);
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
        input [15:0] expected_ciphertext;
        input expected_done;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h, done=%b",
                         ciphertext, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h, done=%b",
                         expected_ciphertext, expected_done);
                $display("  Got:      ciphertext=%h, done=%b",
                         ciphertext, done);
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
        $dumpvars(0,clk, exponent, modulus, plaintext, reset, ciphertext, done);
    end

endmodule
