`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg decrypt;
    reg [31:0] line0;
    reg [31:0] line1;
    reg [31:0] line2;
    reg [31:0] line3;
    reg ready;
    wire [31:0] outline0;
    wire [31:0] outline1;
    wire [31:0] outline2;
    wire [31:0] outline3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .decrypt(decrypt),
        .line0(line0),
        .line1(line1),
        .line2(line2),
        .line3(line3),
        .ready(ready),
        .outline0(outline0),
        .outline1(outline1),
        .outline2(outline2),
        .outline3(outline3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Encryption (Left Shift)", test_num);

        ready = 0; decrypt = 0; line0 = 0; line1 = 0; line2 = 0; line3 = 0;
        @(posedge clk);

        ready = 1;
        decrypt = 0;
        line0 = 32'h00010203;
        line1 = 32'h10111213;
        line2 = 32'h20212223;
        line3 = 32'h30313233;
        @(posedge clk);
        #1;

        check_outputs(32'h00010203, 32'h11121310, 32'h22232021, 32'h33303132);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Encryption with Distinct Bytes", test_num);
        ready = 0; @(posedge clk);
        ready = 1;
        decrypt = 0;
        line0 = 32'hAABBCCDD;
        line1 = 32'h11223344;
        line2 = 32'h55667788;
        line3 = 32'h9900AABB;
        @(posedge clk);
        #1;

        check_outputs(32'hAABBCCDD, 32'h22334411, 32'h77885566, 32'hBB9900AA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decryption (Inverse Shift)", test_num);
        ready = 0; @(posedge clk);
        ready = 1;
        decrypt = 1;
        line0 = 32'h00010203;
        line1 = 32'h10111213;
        line2 = 32'h20212223;
        line3 = 32'h30313233;
        @(posedge clk);
        #1;

        check_outputs(32'h00010203, 32'h13101112, 32'h22232021, 32'h31323330);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Ready Signal Low", test_num);
        ready = 0;
        decrypt = 0;
        line0 = 32'hFFFFFFFF;
        line1 = 32'hFFFFFFFF;
        line2 = 32'hFFFFFFFF;
        line3 = 32'hFFFFFFFF;
        @(posedge clk);

        #1;


        check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Edge Case - All Ones", test_num);
        ready = 0; @(posedge clk);
        ready = 1;
        decrypt = 0;
        line0 = 32'hFFFFFFFF;
        line1 = 32'hFFFFFFFF;
        line2 = 32'hFFFFFFFF;
        line3 = 32'hFFFFFFFF;
        @(posedge clk);
        #1;

        check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF);
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
        input [31:0] expected_outline0;
        input [31:0] expected_outline1;
        input [31:0] expected_outline2;
        input [31:0] expected_outline3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outline0 === (expected_outline0 ^ outline0 ^ expected_outline0) &&
                expected_outline1 === (expected_outline1 ^ outline1 ^ expected_outline1) &&
                expected_outline2 === (expected_outline2 ^ outline2 ^ expected_outline2) &&
                expected_outline3 === (expected_outline3 ^ outline3 ^ expected_outline3)) begin
                $display("PASS");
                $display("  Outputs: outline0=%h, outline1=%h, outline2=%h, outline3=%h",
                         outline0, outline1, outline2, outline3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outline0=%h, outline1=%h, outline2=%h, outline3=%h",
                         expected_outline0, expected_outline1, expected_outline2, expected_outline3);
                $display("  Got:      outline0=%h, outline1=%h, outline2=%h, outline3=%h",
                         outline0, outline1, outline2, outline3);
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
