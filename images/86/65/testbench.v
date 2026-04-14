`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg back;
    reg clk;
    reg [31:0] pixaddr;
    reg ven;
    wire breq;
    wire [31:0] qpixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .back(back),
        .clk(clk),
        .pixaddr(pixaddr),
        .ven(ven),
        .breq(breq),
        .qpixel(qpixel)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("testcase001: System Idle State");


        ven = 0;
        pixaddr = 32'h0;
        back = 0;

        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("testcase002: Asserting ven and checking breq");


        ven = 0; @(posedge clk);


        ven = 1;
        pixaddr = 32'hA5A5_B6B6;
        back = 0;

        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b1, 32'hA5A5_B6B6);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("testcase003: Sequential Address Update");

        ven = 1;
        pixaddr = 32'h1234_5678;
        @(posedge clk);
        #1;

        pixaddr = 32'hDEAD_BEEF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 32'hDEAD_BEEF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("testcase004: Control Signal 'back' interaction");

        ven = 1;
        pixaddr = 32'h0000_FFFF;
        back = 1;

        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 32'h0000_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("testcase005: De-assertion of ven");

        ven = 1;
        @(posedge clk);

        ven = 0;
        pixaddr = 32'h0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 32'h0);
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
        input expected_breq;
        input [31:0] expected_qpixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_breq === (expected_breq ^ breq ^ expected_breq) &&
                expected_qpixel === (expected_qpixel ^ qpixel ^ expected_qpixel)) begin
                $display("PASS");
                $display("  Outputs: breq=%b, qpixel=%h",
                         breq, qpixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: breq=%b, qpixel=%h",
                         expected_breq, expected_qpixel);
                $display("  Got:      breq=%b, qpixel=%h",
                         breq, qpixel);
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
