`timescale 1ns/1ps

module rsa_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] exponent;
    reg [9:0] modulus;
    reg [9:0] plaintext;
    reg rst;
    wire [9:0] ciphertext;

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
            plaintext = 0;
            exponent = 0;
            modulus = 0;
            repeat (2) @(posedge clk);
            rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case %0d: Basic small value calculation", test_num);
            plaintext = 10'd3;
            exponent = 8'd4;
            modulus = 10'd50;

            repeat (32) @(posedge clk);
            #1;

            check_outputs(10'd31);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case %0d: Exponent of 1", test_num);
            plaintext = 10'd123;
            exponent = 8'd1;
            modulus = 10'd997;
            repeat (32) @(posedge clk);
            #1;

            check_outputs(10'd123);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case %0d: Plaintext 1 to high power", test_num);
            plaintext = 10'd1;
            exponent = 8'd255;
            modulus = 10'd1023;
            repeat (32) @(posedge clk);
            #1;

            check_outputs(10'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case %0d: Result equals zero", test_num);
            plaintext = 10'd10;
            exponent = 8'd2;
            modulus = 10'd100;
            repeat (32) @(posedge clk);
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case %0d: Intermediate overflow check", test_num);
            plaintext = 10'd7;
            exponent = 8'd3;
            modulus = 10'd100;
            repeat (32) @(posedge clk);
            #1;

            check_outputs(10'd43);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test Case %0d: Large exponent", test_num);
            plaintext = 10'd2;
            exponent = 8'd10;
            modulus = 10'd1000;
            repeat (32) @(posedge clk);
            #1;

            check_outputs(10'd24);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test Case %0d: Modulus of 1", test_num);
            plaintext = 10'd55;
            exponent = 8'd7;
            modulus = 10'd1;
            repeat (32) @(posedge clk);
            #1;

            check_outputs(10'd0);
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
        input [9:0] expected_ciphertext;
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
