`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] message;
    wire [127:0] hmac_out;

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
            $display("Test Case %0d: All Zeros", test_num);
            key = 128'h0;
            message = 128'h0;
            #1;

            check_outputs(hmac_model(key, message));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            key = {128{1'b1}};
            message = {128{1'b1}};
            #1;

            check_outputs(hmac_model(key, message));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical Key and Message", test_num);
            key = 128'hABCDEFFEDCBA0123456789ABCDEF0123;
            message = 128'hABCDEFFEDCBA0123456789ABCDEF0123;
            #1;

            check_outputs(hmac_model(key, message));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary Bit Patterns", test_num);
            key = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            message = 128'h55555555555555555555555555555555;
            #1;

            check_outputs(hmac_model(key, message));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Key with Message", test_num);
            key = 128'h0;
            message = 128'hDEADBEEFCAFEBABE1234567887654321;
            #1;

            check_outputs(hmac_model(key, message));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Bit Toggle", test_num);
            key = 128'h80000000000000000000000000000000;
            message = 128'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(hmac_model(key, message));
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Set", test_num);
            key = 128'h00000000000000000000000000000001;
            message = 128'h00000000000000000000000000000100;
            #1;

            check_outputs(hmac_model(key, message));
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
        input [127:0] expected_hmac_out;
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
