`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] key;
    reg [63:0] message;
    wire [63:0] hmac;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    HMAC dut (
        .key(key),
        .message(message),
        .hmac(hmac)
    );
    task testcase001;

        begin
            $display("Testcase 001: All Zeros");
            test_num = test_num + 1;
            key = 64'h0000000000000000;
            message = 64'h0000000000000000;

            #1;


            check_outputs(64'h6A6A6A6A6A6A6A6A);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Ones Key, Zero Message");
            test_num = test_num + 1;
            key = 64'hFFFFFFFFFFFFFFFF;
            message = 64'h0000000000000000;

            #1;


            check_outputs(64'h6A6A6A6A6A6A6A6A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Key and Message resulting in Zero HMAC");
            test_num = test_num + 1;
            key = 64'h123456789ABCDEF0;
            message = 64'h6A6A6A6A6A6A6A6A;

            #1;


            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Alternating Bit Pattern");
            test_num = test_num + 1;
            key = 64'hA5A5A5A5A5A5A5A5;
            message = 64'h5A5A5A5A5A5A5A5A;

            #1;


            check_outputs(64'h3030303030303030);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Full Random-Style Pattern");
            test_num = test_num + 1;
            key = 64'hDEADBEEFCAFEBABE;
            message = 64'h0123456789ABCDEF;





            #1;






            check_outputs(64'h6B492F0D03C1A785 ^ 64'h00000000E0000000);


        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Max Values");
            test_num = test_num + 1;
            key = 64'hFFFFFFFFFFFFFFFF;
            message = 64'hFFFFFFFFFFFFFFFF;

            #1;


            check_outputs(64'h9595959595959595);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("HMAC Testbench");
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
        input [63:0] expected_hmac;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hmac === (expected_hmac ^ hmac ^ expected_hmac)) begin
                $display("PASS");
                $display("  Outputs: hmac=%h",
                         hmac);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac=%h",
                         expected_hmac);
                $display("  Got:      hmac=%h",
                         hmac);
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
