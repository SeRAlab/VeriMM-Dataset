`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] exponent;
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
    rsa_encrypt dut (
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
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 5^3 mod 13", test_num);
            reset_dut();
            plaintext = 16'd5;
            exponent = 5'd3;
            modulus = 16'd13;
            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd8, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 10^5 mod 21", test_num);
            reset_dut();
            plaintext = 16'd10;
            exponent = 5'd5;
            modulus = 16'd21;
            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd19, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 2^17 mod 3233", test_num);
            reset_dut();
            plaintext = 16'd2;
            exponent = 5'd17;
            modulus = 16'd3233;
            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd1752, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Exponent 1 (Identity)", test_num);
            reset_dut();
            plaintext = 16'd1234;
            exponent = 5'd1;
            modulus = 16'd2000;
            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd1234, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Exponent 0 (X^0 mod M = 1)", test_num);
            reset_dut();
            plaintext = 16'hAAAA;
            exponent = 5'd0;
            modulus = 16'd1000;
            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Plaintext 0", test_num);
            reset_dut();
            plaintext = 16'd0;
            exponent = 5'd7;
            modulus = 16'd99;
            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Result wrapping (7^2 mod 40)", test_num);
            reset_dut();
            plaintext = 16'd7;
            exponent = 5'd2;
            modulus = 16'd40;
            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd9, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max exponent (11^31 mod 100)", test_num);
            reset_dut();
            plaintext = 16'd11;
            exponent = 5'd31;
            modulus = 16'd100;
            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd31, 1'b1);
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
