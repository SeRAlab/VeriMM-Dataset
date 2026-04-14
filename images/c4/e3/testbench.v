`timescale 1ns/1ps

module encryption_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg key;
    reg plaintext;
    reg reset;
    wire ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encryption_module dut (
        .clk(clk),
        .enable(enable),
        .key(key),
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
            enable = 0;
            key = 0;
            plaintext = 0;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Enable=1, Plaintext=0, Key=0", test_num);
            enable = 1;
            plaintext = 0;
            key = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Enable=1, Plaintext=1, Key=0", test_num);
            enable = 1;
            plaintext = 1;
            key = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Enable=1, Plaintext=0, Key=1", test_num);
            enable = 1;
            plaintext = 0;
            key = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Enable=1, Plaintext=1, Key=1", test_num);
            enable = 1;
            plaintext = 1;
            key = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Enable=0, Plaintext=1, Key=1", test_num);
            enable = 0;
            plaintext = 1;
            key = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Enable=0, Plaintext=1, Key=0", test_num);
            enable = 0;
            plaintext = 1;
            key = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential logic check", test_num);
            enable = 1; plaintext = 1; key = 0;
            @(posedge clk);
            #1;
            plaintext = 0; key = 1;
            #1;

            check_outputs(1);

            @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encryption_module Testbench");
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
        input expected_ciphertext;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%b",
                         ciphertext);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%b",
                         expected_ciphertext);
                $display("  Got:      ciphertext=%b",
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
        $dumpvars(0,clk, enable, key, plaintext, reset, ciphertext);
    end

endmodule
