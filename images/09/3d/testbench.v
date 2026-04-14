`timescale 1ns/1ps

module chacha20_round_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] block_counter;
    reg [31:0] key;
    reg [31:0] nonce;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_round dut (
        .block_counter(block_counter),
        .key(key),
        .nonce(nonce),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            key           = 32'h00000000;
            nonce         = 32'h00000000;
            block_counter = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Addition (No Overflow)", test_num);
            key           = 32'h00000010;
            nonce         = 32'h00000020;
            block_counter = 32'h00000030;
            #1;

            check_outputs(32'h00000060);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Overflow", test_num);
            key           = 32'hFFFFFFFF;
            nonce         = 32'h00000001;
            block_counter = 32'h00000005;

            #1;


            check_outputs(32'h00000005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Possible Values (Double Overflow)", test_num);
            key           = 32'hFFFFFFFF;
            nonce         = 32'hFFFFFFFF;
            block_counter = 32'hFFFFFFFF;


            #1;



            check_outputs(32'hFFFFFFFD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Exact Power of 2 Overflow", test_num);
            key           = 32'h80000000;
            nonce         = 32'h40000000;
            block_counter = 32'h40000000;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random-style Hex Values", test_num);
            key           = 32'h12345678;
            nonce         = 32'h87654321;
            block_counter = 32'h00000001;

            #1;


            check_outputs(32'h9999999A);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits", test_num);
            key           = 32'hAAAAAAAA;
            nonce         = 32'h55555555;
            block_counter = 32'h00000001;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_round Testbench");
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
