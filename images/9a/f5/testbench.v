`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] validdata;
    wire wCa;
    wire wCb;
    wire [15:0] wInstruction;
    wire wNa;
    wire wNb;
    wire wZa;
    wire wZb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .validdata(validdata),
        .wCa(wCa),
        .wCb(wCb),
        .wInstruction(wInstruction),
        .wNa(wNa),
        .wNb(wNb),
        .wZa(wZa),
        .wZb(wZb)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Testing validdata = 8");
            validdata = 8'd8;



            #1;




            check_outputs(1'b0, 1'b0, 16'h0008, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Testing validdata = 16");
            validdata = 8'd16;

            #1;


            check_outputs(1'b0, 1'b0, 16'h0010, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Testing validdata = 32");
            validdata = 8'd32;

            #1;


            check_outputs(1'b1, 1'b0, 16'h0020, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Testing validdata = 64");
            validdata = 8'd64;

            #1;


            check_outputs(1'b0, 1'b1, 16'h0040, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Testing validdata = 0 (Default)");
            validdata = 8'd0;

            #1;


            check_outputs(1'b0, 1'b0, 16'h0000, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Testing validdata = 255 (Undefined input)");
            validdata = 8'd255;

            #1;


            check_outputs(1'b0, 1'b0, 16'h0000, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_wCa;
        input expected_wCb;
        input [15:0] expected_wInstruction;
        input expected_wNa;
        input expected_wNb;
        input expected_wZa;
        input expected_wZb;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_wCa === (expected_wCa ^ wCa ^ expected_wCa) &&
                expected_wCb === (expected_wCb ^ wCb ^ expected_wCb) &&
                expected_wInstruction === (expected_wInstruction ^ wInstruction ^ expected_wInstruction) &&
                expected_wNa === (expected_wNa ^ wNa ^ expected_wNa) &&
                expected_wNb === (expected_wNb ^ wNb ^ expected_wNb) &&
                expected_wZa === (expected_wZa ^ wZa ^ expected_wZa) &&
                expected_wZb === (expected_wZb ^ wZb ^ expected_wZb)) begin
                $display("PASS");
                $display("  Outputs: wCa=%b, wCb=%b, wInstruction=%h, wNa=%b, wNb=%b, wZa=%b, wZb=%b",
                         wCa, wCb, wInstruction, wNa, wNb, wZa, wZb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wCa=%b, wCb=%b, wInstruction=%h, wNa=%b, wNb=%b, wZa=%b, wZb=%b",
                         expected_wCa, expected_wCb, expected_wInstruction, expected_wNa, expected_wNb, expected_wZa, expected_wZb);
                $display("  Got:      wCa=%b, wCb=%b, wInstruction=%h, wNa=%b, wNb=%b, wZa=%b, wZb=%b",
                         wCa, wCb, wInstruction, wNa, wNb, wZa, wZb);
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
