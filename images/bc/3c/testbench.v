`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg [63:0] in;
    reg [127:0] key;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .in(in),
        .key(key),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Encryption", test_num);
            ctrl = 2'd0;
            in = 64'h0123456789ABCDEF;
            key = 128'hFEDCBA98765432100123456789ABCDEF;


            #1;



            check_outputs(dut.encryption(in, key));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Decryption", test_num);
            ctrl = 2'd1;
            in = 64'hABCDEF0123456789;
            key = 128'h00112233445566778899AABBCCDDEEFF;
            #1;

            check_outputs(dut.decryption(in, key));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Hashing", test_num);
            ctrl = 2'd2;
            in = 64'hDEADBEEFCAFEBABE;
            key = 128'h0;
            #1;

            check_outputs(dut.hashing(in));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All-Zero Boundary", test_num);
            ctrl = 2'd0;
            in = 64'h0;
            key = 128'h0;
            #1;

            check_outputs(dut.encryption(64'h0, 128'h0));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Key Sensitivity", test_num);
            ctrl = 2'd0;
            in = 64'hA5A5A5A5A5A5A5A5;
            key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(dut.encryption(64'hA5A5A5A5A5A5A5A5, 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF));
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
        input [63:0] expected_out;
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
