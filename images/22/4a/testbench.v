`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] key;
    reg [7:0] message;
    wire [7:0] hmac;

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
        $display("Running Test Case %0d: All Zeros", test_num);
        key = 8'h00;
        message = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: All Ones", test_num);
        key = 8'hFF;
        message = 8'hFF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Key FF, Message 00", test_num);
        key = 8'hFF;
        message = 8'h00;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Message FF, Key 00", test_num);
        key = 8'h00;
        message = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Alternating Bits", test_num);
        key = 8'hAA;
        message = 8'h55;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Hex 12 and 34", test_num);
        key = 8'h12;
        message = 8'h34;
        #1;

        check_outputs(8'h26);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Upper and Lower Nibbles", test_num);
        key = 8'hF0;
        message = 8'h0F;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Complex Pattern", test_num);
        key = 8'hDE;
        message = 8'hAD;
        #1;

        check_outputs(8'h73);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Prime-like bits", test_num);
        key = 8'hC3;
        message = 8'h3C;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Random Identity", test_num);
        key = 8'h5A;
        message = 8'hA5;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_hmac;
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
