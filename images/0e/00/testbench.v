`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] key;
    reg [3:0] message;
    wire [3:0] hmac_output;

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
            $display("Test Case %0d: Key=0, Message=0", test_num);
            key = 4'h0;
            message = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key=F, Message=0", test_num);
            key = 4'hF;
            message = 4'h0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key=0, Message=F", test_num);
            key = 4'h0;
            message = 4'hF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key=F, Message=F", test_num);
            key = 4'hF;
            message = 4'hF;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key=A, Message=5", test_num);
            key = 4'hA;
            message = 4'h5;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key=5, Message=A", test_num);
            key = 4'h5;
            message = 4'hA;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key=3, Message=9", test_num);
            key = 4'h3;
            message = 4'h9;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key=C, Message=6", test_num);
            key = 4'hC;
            message = 4'h6;
            #1;

            check_outputs(4'hA);
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
        input [3:0] expected_hmac_output;
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
