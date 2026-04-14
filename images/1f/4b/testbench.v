`timescale 1ns/1ps

module chacha_simple_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] block_index;
    reg [31:0] key;
    reg [31:0] nonce;
    wire [31:0] keystream;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha_simple dut (
        .block_index(block_index),
        .key(key),
        .nonce(nonce),
        .keystream(keystream)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            key = 32'h00000000;
            nonce = 32'h00000000;
            block_index = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition", test_num);
            key = 32'h00000010;
            nonce = 32'h00000020;
            block_index = 32'h00000005;
            #1;

            check_outputs(32'h00000035);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Overflow", test_num);
            key = 32'hFFFFFFFF;
            nonce = 32'h00000001;
            block_index = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Values", test_num);
            key = 32'h12345678;
            nonce = 32'h87654321;
            block_index = 32'h00000001;
            #1;

            check_outputs(32'h9999999A);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Triple Max Overflow", test_num);
            key = 32'hFFFFFFFF;
            nonce = 32'hFFFFFFFF;
            block_index = 32'hFFFFFFFF;


            #1;



            check_outputs(32'hFFFFFFFD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Key Small Others", test_num);
            key = 32'hABCDE000;
            nonce = 32'h00000F00;
            block_index = 32'h000000FF;
            #1;

            check_outputs(32'hABCDEFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha_simple Testbench");
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
        input [31:0] expected_keystream;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_keystream === (expected_keystream ^ keystream ^ expected_keystream)) begin
                $display("PASS");
                $display("  Outputs: keystream=%h",
                         keystream);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: keystream=%h",
                         expected_keystream);
                $display("  Got:      keystream=%h",
                         keystream);
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
