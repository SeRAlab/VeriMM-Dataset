`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ifid_out;
    wire [31:0] sign_ex_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ifid_out(ifid_out),
        .sign_ex_out(sign_ex_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero value", test_num);
        ifid_out = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Positive value (bit 15 is 0)", test_num);
        ifid_out = 32'h00001234;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Maximum positive 16-bit signed integer", test_num);
        ifid_out = 32'h00007FFF;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Minimum negative 16-bit signed integer (bit 15 is 1)", test_num);
        ifid_out = 32'h00008000;
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: All ones in lower 16 bits (-1)", test_num);
        ifid_out = 32'h0000FFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Ignore upper 16 bits of input (Positive lower)", test_num);
        ifid_out = 32'hABCD0001;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Ignore upper 16 bits of input (Negative lower)", test_num);
        ifid_out = 32'h12348ABC;
        #1;

        check_outputs(32'hFFFF8ABC);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Arbitrary pattern with sign bit set", test_num);
        ifid_out = 32'hFFFFF000;
        #1;

        check_outputs(32'hFFFFF000);
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
        input [31:0] expected_sign_ex_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sign_ex_out === (expected_sign_ex_out ^ sign_ex_out ^ expected_sign_ex_out)) begin
                $display("PASS");
                $display("  Outputs: sign_ex_out=%h",
                         sign_ex_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sign_ex_out=%h",
                         expected_sign_ex_out);
                $display("  Got:      sign_ex_out=%h",
                         sign_ex_out);
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
