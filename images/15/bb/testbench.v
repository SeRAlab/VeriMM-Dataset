`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] message;
    wire [127:0] hmac_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac dut (
        .key(key),
        .message(message),
        .hmac_output(hmac_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        key = 128'h0;
        message = 128'h0;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Fs Key, Zero Message", test_num);
        key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        message = 128'h0;
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Key, All Fs Message", test_num);
        key = 128'h0;
        message = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Key and Message same value", test_num);
        key = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
        message = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bit patterns", test_num);
        key = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        message = 128'h55555555555555555555555555555555;
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary Hex Values", test_num);
        key = 128'h123456789ABCDEF00FEDCBA987654321;
        message = 128'hFEDCBA9876543210123456789ABCDEF0;

        #1;


        check_outputs(128'hEC8E8E8E8E8E8E8EEDCBA9811D9B9DD1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single bit difference", test_num);
        key = 128'h00000000000000000000000000000001;
        message = 128'h0;
        #1;

        check_outputs(128'h1);
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
        input [127:0] expected_hmac_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hmac_output === (expected_hmac_output ^ hmac_output ^ expected_hmac_output)) begin
                $display("PASS");
                $display("  Outputs: hmac_output=%h",
                         hmac_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac_output=%h",
                         expected_hmac_output);
                $display("  Got:      hmac_output=%h",
                         hmac_output);
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
