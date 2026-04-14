`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] msg;
    wire [127:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .msg(msg),
        .hash(hash)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 64-bit Zero Input", test_num);
        msg = 64'h0000000000000000;
        #1;

        check_outputs(128'hf312384a32b6045d070b4f8d975da60a);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ASCII 'abcdefgh'", test_num);
        msg = 64'h6162636465666768;
        #1;

        check_outputs(128'he8dc4081b13434b45189a048e585630d);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 64-bit All Ones", test_num);
        msg = 64'hffffffffffffffff;
        #1;

        check_outputs(128'h5f1710609f086e3790100f91e9218e26);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hex Sequence 0123...CDEF", test_num);
        msg = 64'h0123456789abcdef;
        #1;

        check_outputs(128'h5818988663b652613d2f95c52c033816);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits (0101...)", test_num);
        msg = 64'h5555555555555555;
        #1;

        check_outputs(128'h4668b57732d84787943d04d7c0018f3c);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits (1010...)", test_num);
        msg = 64'haaaaaaaaaaaaaaaa;
        #1;

        check_outputs(128'hb22216893693f9c313203f5727f719b0);
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
        input [127:0] expected_hash;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: hash=%h",
                         hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h",
                         expected_hash);
                $display("  Got:      hash=%h",
                         hash);
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
