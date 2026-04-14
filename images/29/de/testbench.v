`timescale 1ns/1ps

module hmac_simple_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] message;
    wire [127:0] hmac;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac_simple dut (
        .key(key),
        .message(message),
        .hmac(hmac)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            key = 128'h0;
            message = 128'h0;
            #1;

            check_outputs(message ^ HMAC_DIFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Key, Zero Message", test_num);
            key = 128'hffffffffffffffffffffffffffffffff;
            message = 128'h0;
            #1;

            check_outputs(message ^ HMAC_DIFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Key, All Ones Message", test_num);
            key = 128'h0;
            message = 128'hffffffffffffffffffffffffffffffff;
            #1;

            check_outputs(message ^ HMAC_DIFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incremental Pattern", test_num);
            key = 128'h0123456789abcdeffedcba9876543210;
            message = 128'h0123456789abcdeffedcba9876543210;
            #1;

            check_outputs(message ^ HMAC_DIFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            key = 128'h55555555555555555555555555555555;
            message = 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
            #1;

            check_outputs(message ^ HMAC_DIFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac_simple Testbench");
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
        input [127:0] expected_hmac;
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
