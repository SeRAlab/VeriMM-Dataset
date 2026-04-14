`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] key;
    reg [63:0] message;
    wire [63:0] hmac_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac dut (
        .key(key),
        .message(message),
        .hmac_out(hmac_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: All Zeros");
        key = 64'h0000000000000000;
        message = 64'h0000000000000000;
        #1;

        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Key all 1s, Message all 0s");
        key = 64'hFFFFFFFFFFFFFFFF;
        message = 64'h0000000000000000;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Key all 0s, Message all 1s");
        key = 64'h0000000000000000;
        message = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Identical Key and Message (Result should be 0)");
        key = 64'hA5A5A5A5A5A5A5A5;
        message = 64'hA5A5A5A5A5A5A5A5;
        #1;

        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Alternating Bit Patterns");
        key = 64'hAAAAAAAAAAAAAAAA;
        message = 64'h5555555555555555;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Random Pattern 1");
        key = 64'h123456789ABCDEF0;
        message = 64'h0F0F0F0F0F0F0F0F;
        #1;

        check_outputs(64'h1D3B597795B3D1FF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Complementary Hex Values");
        key = 64'hFEDCBA9876543210;
        message = 64'h0123456789ABCDEF;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Specific Constant Verification");
        key = 64'hDEADBEEFCAFEBABE;
        message = 64'h1234567812345678;
        #1;

        check_outputs(64'hCC99E897D8CAEC66);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac Testbench");
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
        input [63:0] expected_hmac_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hmac_out === (expected_hmac_out ^ hmac_out ^ expected_hmac_out)) begin
                $display("PASS");
                $display("  Outputs: hmac_out=%h",
                         hmac_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac_out=%h",
                         expected_hmac_out);
                $display("  Got:      hmac_out=%h",
                         hmac_out);
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
