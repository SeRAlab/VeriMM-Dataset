`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1023:0] bloom_table;
    reg [9:0] hash1;
    reg [9:0] hash2;
    reg hash_ready;
    wire is_bad_word;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bloom_table(bloom_table),
        .hash1(hash1),
        .hash2(hash2),
        .hash_ready(hash_ready),
        .is_bad_word(is_bad_word)
    );
    task testcase001;

        begin
            test_num = 1;
            bloom_table = 1024'b0;
            bloom_table[10] = 1'b1;
            bloom_table[20] = 1'b1;
            hash1 = 10'd10;
            hash2 = 10'd20;
            hash_ready = 1'b1;
            $display("Test %0d: Both hashes present, hash_ready=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            bloom_table = 1024'b0;
            bloom_table[10] = 1'b1;
            bloom_table[20] = 1'b0;
            hash1 = 10'd10;
            hash2 = 10'd20;
            hash_ready = 1'b1;
            $display("Test %0d: Only hash1 present, hash_ready=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            bloom_table = 1024'b0;
            bloom_table[10] = 1'b0;
            bloom_table[20] = 1'b1;
            hash1 = 10'd10;
            hash2 = 10'd20;
            hash_ready = 1'b1;
            $display("Test %0d: Only hash2 present, hash_ready=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            bloom_table = 1024'b0;
            hash1 = 10'd100;
            hash2 = 10'd200;
            hash_ready = 1'b1;
            $display("Test %0d: Neither hash present, hash_ready=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            bloom_table = 1024'b0;
            hash1 = 10'd5;
            hash2 = 10'd5;
            hash_ready = 1'b1;
            #2;

            hash_ready = 1'b0;
            bloom_table[5] = 1'b1;
            hash1 = 10'd5;
            hash2 = 10'd5;
            $display("Test %0d: hash_ready dropped from 1->0 (holding '0' logic)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            bloom_table = 1024'b0;
            bloom_table[500] = 1'b1;
            bloom_table[600] = 1'b1;
            hash1 = 10'd500;
            hash2 = 10'd600;
            hash_ready = 1'b1;
            #2;

            hash_ready = 1'b0;
            hash1 = 10'd1;
            hash2 = 10'd2;
            $display("Test %0d: hash_ready dropped from 1->0 (holding '1' logic)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            bloom_table = 1024'b0;
            bloom_table[777] = 1'b1;
            hash1 = 10'd777;
            hash2 = 10'd777;
            hash_ready = 1'b1;
            $display("Test %0d: hash1 and hash2 are identical and present", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            bloom_table = 1024'b0;
            bloom_table[0] = 1'b1;
            bloom_table[1023] = 1'b1;
            hash1 = 10'd0;
            hash2 = 10'd1023;
            hash_ready = 1'b1;
            $display("Test %0d: Boundary indices 0 and 1023", test_num);
            #1;

            check_outputs(1'b1);
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
        input expected_is_bad_word;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_bad_word === (expected_is_bad_word ^ is_bad_word ^ expected_is_bad_word)) begin
                $display("PASS");
                $display("  Outputs: is_bad_word=%b",
                         is_bad_word);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_bad_word=%b",
                         expected_is_bad_word);
                $display("  Got:      is_bad_word=%b",
                         is_bad_word);
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
