`timescale 1ns/1ps

module RSA_Encryptor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] e;
    reg [15:0] n;
    reg [15:0] plaintext;
    reg reset;
    wire [15:0] ciphertext;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RSA_Encryptor dut (
        .clk(clk),
        .e(e),
        .n(n),
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
            plaintext = 0;
            e = 0;
            n = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic small numbers (2^3 mod 11)", test_num);
            reset_dut();
            plaintext = 16'd2;
            e = 16'd3;
            n = 16'd11;


            @(posedge clk);
            wait(ready == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(16'd8, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Plaintext = 1", test_num);
            reset_dut();
            plaintext = 16'd1;
            e = 16'd17;
            n = 16'd3233;

            @(posedge clk);
            wait(ready == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(16'd1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Plaintext = 0", test_num);
            reset_dut();
            plaintext = 16'd0;
            e = 16'd7;
            n = 16'd33;

            @(posedge clk);
            wait(ready == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(16'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Standard RSA Example (65^17 mod 3233)", test_num);
            reset_dut();
            plaintext = 16'd65;
            e = 16'd17;
            n = 16'd3233;

            @(posedge clk);
            wait(ready == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(16'd2790, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Modulo wrapping (7^11 mod 13)", test_num);
            reset_dut();
            plaintext = 16'd7;
            e = 16'd11;
            n = 16'd13;

            @(posedge clk);
            wait(ready == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(16'd2, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large input (123^17 mod 3233)", test_num);
            reset_dut();
            plaintext = 16'd123;
            e = 16'd17;
            n = 16'd3233;

            @(posedge clk);
            wait(ready == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(16'd855, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power calculation (15^3 mod 100)", test_num);
            reset_dut();
            plaintext = 16'd15;
            e = 16'd3;
            n = 16'd100;

            @(posedge clk);
            wait(ready == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(16'd75, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RSA_Encryptor Testbench");
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
        $dumpvars(0,clk, e, n, plaintext, reset, ciphertext, ready);
    end

endmodule
