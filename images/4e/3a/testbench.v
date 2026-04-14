`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg [127:0] data;
    reg [127:0] key;
    wire [127:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .data(data),
        .key(key),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Encryption - FIPS 197 Standard Vector", test_num);
            ctrl = 1'b0;
            key  = 128'h000102030405060708090a0b0c0d0e0f;
            data = 128'h00112233445566778899aabbccddeeff;
            #1;

            check_outputs(128'h69c4e0d86a7b0430d8cdb78070b4c55a);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Decryption - FIPS 197 Standard Vector", test_num);
            ctrl = 1'b1;
            key  = 128'h000102030405060708090a0b0c0d0e0f;
            data = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
            #1;

            check_outputs(128'h00112233445566778899aabbccddeeff);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Encryption - NIST SP800-38A Vector", test_num);
            ctrl = 1'b0;
            key  = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            data = 128'h6bc1bee22e409f96e93d7e117393172a;
            #1;

            check_outputs(128'h3ad77bb40d7a3660a89ecaf32466ef97);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Decryption - NIST SP800-38A Vector", test_num);
            ctrl = 1'b1;
            key  = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            data = 128'h3ad77bb40d7a3660a89ecaf32466ef97;
            #1;

            check_outputs(128'h6bc1bee22e409f96e93d7e117393172a);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Encryption - All Zeros Case", test_num);
            ctrl = 1'b0;
            key  = 128'h00000000000000000000000000000000;
            data = 128'h00000000000000000000000000000000;
            #1;

            check_outputs(128'h66e94bd4ef8a2c3b884cfa59ca342b2e);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Decryption - All Zeros Input Result", test_num);
            ctrl = 1'b1;
            key  = 128'h00000000000000000000000000000000;
            data = 128'h66e94bd4ef8a2c3b884cfa59ca342b2e;
            #1;

            check_outputs(128'h00000000000000000000000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Encryption - All Ones Key", test_num);
            ctrl = 1'b0;
            key  = 128'hffffffffffffffffffffffffffffffff;
            data = 128'h00000000000000000000000000000000;
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
        $display("top_module Testbench");
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
        input [127:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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

endmodule
