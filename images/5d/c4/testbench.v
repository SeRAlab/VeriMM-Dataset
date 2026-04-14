`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] state_in;
    wire [127:0] state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .key(key),
        .state_in(state_in),
        .state_out(state_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR with all zeros", test_num);
            state_in = 128'h123456789ABCDEF0FEDCBA9876543210;
            key      = 128'h00000000000000000000000000000000;
            #1;

            check_outputs(128'h123456789ABCDEF0FEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR with self", test_num);
            state_in = 128'hA5A5A5A5A5A5A5A55A5A5A5A5A5A5A5A;
            key      = 128'hA5A5A5A5A5A5A5A55A5A5A5A5A5A5A5A;
            #1;

            check_outputs(128'h00000000000000000000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR with all ones (Bitwise inversion)", test_num);
            state_in = 128'hFFFFFFFF00000000AAAAAAAA55555555;
            key      = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(128'h00000000FFFFFFF05555555AAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Standard key addition", test_num);
            state_in = 128'h00112233445566778899AABBCCDDEEFF;
            key      = 128'h000102030405060708090A0B0C0D0E0F;
            #1;

            check_outputs(128'h00102030405060708090A0B0C0D0E0F0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed patterns", test_num);
            state_in = 128'hDEADBEEFCAFEBABE1337C0DEB0B0FACE;
            key      = 128'h11111111111111111111111111111111;
            #1;

            check_outputs(128'hCFCFAFFEBBEDABAF0226D1CFB1A1EBDF);
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
        input [127:0] expected_state_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_state_out === (expected_state_out ^ state_out ^ expected_state_out)) begin
                $display("PASS");
                $display("  Outputs: state_out=%h",
                         state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_out=%h",
                         expected_state_out);
                $display("  Got:      state_out=%h",
                         state_out);
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
