`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] key;
    reg [4:0] message;
    wire [4:0] digest;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac dut (
        .key(key),
        .message(message),
        .digest(digest)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            key = 5'b00000;
            message = 5'b00000;
            #10;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            key = 5'b11111;
            message = 5'b11111;
            #10;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key All Ones, Message Zero", test_num);
            key = 5'b11111;
            message = 5'b00000;
            #10;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key Zero, Message All Ones", test_num);
            key = 5'b00000;
            message = 5'b11111;
            #10;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (Pattern A)", test_num);
            key = 5'b10101;
            message = 5'b01010;
            #10;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Bit Pattern 1", test_num);
            key = 5'b11001;
            message = 5'b01101;
            #10;
            #1;

            check_outputs(5'b10100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Bit Pattern 2", test_num);
            key = 5'b00111;
            message = 5'b10100;
            #10;
            #1;

            check_outputs(5'b10011);
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
        input [4:0] expected_digest;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digest === (expected_digest ^ digest ^ expected_digest)) begin
                $display("PASS");
                $display("  Outputs: digest=%h",
                         digest);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digest=%h",
                         expected_digest);
                $display("  Got:      digest=%h",
                         digest);
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
