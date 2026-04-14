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
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Zeros", test_num);
        key = 64'h0000_0000_0000_0000;
        message = 64'h0000_0000_0000_0000;

        #1;


        check_outputs(64'h6A6A6A6A6A6A6A6A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All-Ones Key, Zero Message", test_num);
        key = 64'hFFFF_FFFF_FFFF_FFFF;
        message = 64'h0000_0000_0000_0000;

        #1;


        check_outputs(64'h6A6A6A6A6A6A6A6A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All-Ones Message", test_num);
        key = 64'h0000_0000_0000_0000;
        message = 64'hFFFF_FFFF_FFFF_FFFF;

        #1;


        check_outputs(64'h9595_9595_9595_9595);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating Bit Pattern", test_num);
        key = 64'hAAAA_AAAA_AAAA_AAAA;
        message = 64'h5555_5555_5555_5555;

        #1;


        check_outputs(64'h3F3F_3F3F_3F3F_3F3F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Hex Sequence Message", test_num);
        key = 64'h0123_4567_89AB_CDEF;
        message = 64'h1234_5678_9ABC_DEF0;


        #1;



        check_outputs(64'h785E_3C12_F0D6_B49A);
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
