`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] message;
    wire [127:0] hmac;

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
            $display("Test Case %0d: All Ones", test_num);
            key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            message = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key with Zero Message", test_num);
            key = 128'h123456789ABCDEF0123456789ABCDEF0;
            message = 128'h0;
            #1;

            check_outputs(128'h123456789ABCDEF0123456789ABCDEF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Message with Zero Key", test_num);
            key = 128'h0;
            message = 128'hFEDCBA9876543210FEDCBA9876543210;
            #1;

            check_outputs(128'hFEDCBA9876543210FEDCBA9876543210);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            key = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            message = 128'h55555555555555555555555555555555;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern 1", test_num);
            key = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
            message = 128'h5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Values", test_num);
            key = 128'hDEADBEEFCAFEBABE1234567887654321;
            message = 128'h0123456789ABCDEFDEADBEEFCAFEBABE;

            #1;


            check_outputs(128'hDEADBEEFCAFEBABE1234567887654321 ^ 128'h0123456789ABCDEFDEADBEEFCAFEBABE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB Toggle", test_num);
            key = 128'h80000000000000000000000000000000;
            message = 128'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LSB Toggle", test_num);
            key = 128'h00000000000000000000000000000001;
            message = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Matching Values", test_num);
            key = 128'hABCDE12345F9876543210ABCDEF00000;
            message = 128'hABCDE12345F9876543210ABCDEF00000;
            #1;

            check_outputs(128'h0);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
