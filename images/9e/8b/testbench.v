`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] addr;
    reg [31:0] data_in;
    reg encrypt;
    wire [31:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .data_in(data_in),
        .encrypt(encrypt),
        .data_out(data_out),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Encrypting zero (Expected: Key)", test_num);
            addr = 32'h0000_1000;
            data_in = 32'h0000_0000;
            encrypt = 1'b1;
            #1;

            check_outputs(32'h0000_0000 ^ EXPECTED_KEY, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Encrypting data pattern 0x12345678", test_num);
            addr = 32'h0000_2000;
            data_in = 32'h1234_5678;
            encrypt = 1'b1;
            #2;
            encrypted_temp = data_out;
            #1;

            check_outputs(32'h1234_5678 ^ EXPECTED_KEY, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decrypting result of previous test (Reversibility)", test_num);
            addr = 32'h0000_2000;
            data_in = encrypted_temp;
            encrypt = 1'b0;
            #1;

            check_outputs(32'h1234_5678, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Encrypting 0xFFFFFFFF", test_num);
            addr = 32'hFFFF_FFFF;
            data_in = 32'hFFFF_FFFF;
            encrypt = 1'b1;
            #1;

            check_outputs(32'hFFFF_FFFF ^ EXPECTED_KEY, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying logic consistency across different addresses", test_num);
            addr = 32'hABC0_1234;
            data_in = 32'hCAFE_BABE;
            encrypt = 1'b1;
            #1;

            check_outputs(32'hCAFE_BABE ^ EXPECTED_KEY, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decrypting zero", test_num);
            addr = 32'h0000_0000;
            data_in = 32'h0000_0000;
            encrypt = 1'b0;
            #1;

            check_outputs(32'h0000_0000 ^ EXPECTED_KEY, 1'b1);
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
        input [31:0] expected_data_out;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
