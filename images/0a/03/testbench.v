`timescale 1ns/1ps

module hmac_example_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] key;
    reg [63:0] message;
    wire [63:0] hmac_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac_example dut (
        .key(key),
        .message(message),
        .hmac_output(hmac_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d: All Zeros", test_num);
        key = 64'h0000000000000000;
        message = 64'h0000000000000000;

        #1;


        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d: All Ones", test_num);
        key = 64'hFFFFFFFFFFFFFFFF;
        message = 64'hFFFFFFFFFFFFFFFF;

        #1;


        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d: Complementary Inputs", test_num);
        key = 64'hFFFFFFFFFFFFFFFF;
        message = 64'h0000000000000000;

        #1;


        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d: Alternating Bit Patterns", test_num);
        key = 64'h5555555555555555;
        message = 64'hAAAAAAAAAAAAAAAA;

        #1;


        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d: Identical Non-Zero Patterns", test_num);
        key = 64'h1234567812345678;
        message = 64'h1234567812345678;

        #1;


        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d: Arbitrary Hex Pattern 1", test_num);
        key = 64'h123456789ABCDEF0;
        message = 64'h0FEDCBA987654321;



        #1;




        check_outputs(64'hE22662CEE2662C2E);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d: Single Bit Difference", test_num);
        key = 64'h0000000000000000;
        message = 64'h0000000000000001;

        #1;


        check_outputs(64'hFFFFFFFFFFFFFFFE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac_example Testbench");
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
        input [63:0] expected_hmac_output;
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
