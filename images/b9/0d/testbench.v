`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] channels;
    reg [3:0] select;
    wire [15:0] op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .channels(channels),
        .select(select),
        .op(op)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Channel 0", test_num);
        channels = 256'h0;
        channels[15:0] = 16'h1234;
        select = 4'd0;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Channel 15 (MSB set)", test_num);
        channels = 256'h0;
        channels[255:240] = 16'hF00F;
        select = 4'd15;
        #1;

        check_outputs(16'hF00F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Channel 7 (Middle)", test_num);
        channels = 256'h0;
        channels[127:112] = 16'hABCD;
        select = 4'd7;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All channels unique, select 4", test_num);

        channels[15:0]    = 16'h0000;
        channels[31:16]   = 16'h0001;
        channels[47:32]   = 16'h0002;
        channels[63:48]   = 16'h0003;
        channels[79:64]   = 16'h0004;
        channels[95:80]   = 16'h0005;
        channels[111:96]  = 16'h0006;
        channels[127:112] = 16'h0007;
        channels[143:128] = 16'h0008;
        channels[159:144] = 16'h0009;
        channels[175:160] = 16'h000A;
        channels[191:176] = 16'h000B;
        channels[207:192] = 16'h000C;
        channels[223:208] = 16'h000D;
        channels[239:224] = 16'h000E;
        channels[255:240] = 16'h000F;

        select = 4'd4;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Channel 12 with pattern", test_num);
        channels = 256'h0;
        channels[207:192] = 16'hAAAA;
        select = 4'd12;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Channel 1 with all ones", test_num);
        channels = {256{1'b1}};
        select = 4'd1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Channel 10 with alternating bits", test_num);
        channels = 256'h0;
        channels[175:160] = 16'h5555;
        select = 4'd10;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [15:0] expected_op;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_op === (expected_op ^ op ^ expected_op)) begin
                $display("PASS");
                $display("  Outputs: op=%h",
                         op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op=%h",
                         expected_op);
                $display("  Got:      op=%h",
                         op);
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
