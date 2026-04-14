`timescale 1ns/1ps

module rsa_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] exponent;
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
            plaintext = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Exponent (e=1)", test_num);
            reset_dut();
            plaintext = 16'd1234;
            exponent = 16'd1;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd1234, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Base 0", test_num);
            reset_dut();
            plaintext = 16'd0;
            exponent = 16'd5;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Base 1", test_num);
            reset_dut();
            plaintext = 16'd1;
            exponent = 16'hFFFF;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Exponent 0", test_num);
            reset_dut();
            plaintext = 16'd5678;
            exponent = 16'd0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of 2 (No wrap)", test_num);
            reset_dut();
            plaintext = 16'd2;
            exponent = 16'd10;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd1024, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small wrapping result (257^2)", test_num);
            reset_dut();
            plaintext = 16'd257;
            exponent = 16'd2;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'd512, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Common Encryption (e=3)", test_num);
            reset_dut();
            plaintext = 16'd100;
            exponent = 16'd3;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'h4231, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Plaintext", test_num);
            reset_dut();
            plaintext = 16'hFFFF;
            exponent = 16'd1;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'hFFFF, 1'b1);
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
        $dumpvars(0,clk, exponent, plaintext, reset, ciphertext, done);
    end

endmodule
