`timescale 1ns/1ps

module AES128_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] plaintext;
    reg rst;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AES128 dut (
        .clk(clk),
        .key(key),
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
            key = 0;
            plaintext = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros (NIST Vector)", test_num);
            reset_dut();

            key = 128'h00000000000000000000000000000000;
            plaintext = 128'h00000000000000000000000000000000;


            repeat(20) @(posedge clk);

            #1;


            check_outputs(128'h66e94bd4ef8a2c3b884cfa59ca342b2e);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: FIPS 197 Appendix B Example", test_num);
            reset_dut();

            key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            plaintext = 128'h3243f6a8885a308d313198a2e0370734;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(128'h3925841d02dc09fbdc118597196a0b32);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: NIST SP 800-38A Block 1", test_num);
            reset_dut();

            key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            plaintext = 128'h6bc1bee22e409f96e93d7e117393172a;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(128'h3ad77bb40d7a3660a89ecaf32466ef97);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: NIST SP 800-38A Block 2", test_num);
            reset_dut();

            key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            plaintext = 128'hae2d8a571e03ac9c9eb76fac45af8e51;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(128'hf5d3d58503b9699de785895a96fdbaaf);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones Pattern", test_num);
            reset_dut();

            key = 128'hffffffffffffffffffffffffffffffff;
            plaintext = 128'hffffffffffffffffffffffffffffffff;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(128'ha1f6258c877d5fcd8964484538bfc92c);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AES128 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        $dumpvars(0,clk, key, plaintext, rst, ciphertext);
    end

endmodule
