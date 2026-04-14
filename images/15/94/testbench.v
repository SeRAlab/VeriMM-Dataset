`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] modulus;
    reg [15:0] plaintext;
    reg [7:0] public_exponent;
    reg rst_n;
    wire [15:0] ciphertext;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .clk(clk),
        .modulus(modulus),
        .plaintext(plaintext),
        .public_exponent(public_exponent),
        .rst_n(rst_n),
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
            rst_n = 0;
            plaintext = 0;
            public_exponent = 0;
            modulus = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 2^3 mod 11", test_num);
            plaintext = 16'd2;
            public_exponent = 8'd3;
            modulus = 16'd11;



            wait(ready == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(16'd8, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 3^4 mod 10", test_num);
            plaintext = 16'd3;
            public_exponent = 8'd4;
            modulus = 16'd10;

            wait(ready == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(16'd1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 5^1 mod 13 (Exponent = 1)", test_num);
            plaintext = 16'd5;
            public_exponent = 8'd1;
            modulus = 16'd13;

            wait(ready == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(16'd5, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 7^0 mod 15 (Exponent = 0)", test_num);
            plaintext = 16'd7;
            public_exponent = 8'd0;
            modulus = 16'd15;

            wait(ready == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(16'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 10^5 mod 23", test_num);
            plaintext = 16'd10;
            public_exponent = 8'd5;
            modulus = 16'd23;

            wait(ready == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(16'd19, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 123^3 mod 257", test_num);
            plaintext = 16'd123;
            public_exponent = 8'd3;
            modulus = 16'd257;

            wait(ready == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(16'd187, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 61^7 mod 113", test_num);
            plaintext = 16'd61;
            public_exponent = 8'd7;
            modulus = 16'd113;

            wait(ready == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(16'd69, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Plaintext larger than modulus (15^3 mod 7)", test_num);
            plaintext = 16'd15;
            public_exponent = 8'd3;
            modulus = 16'd7;

            wait(ready == 1'b1);
            @(posedge clk);

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
        $dumpvars(0,clk, modulus, plaintext, public_exponent, rst_n, ciphertext, ready);
    end

endmodule
