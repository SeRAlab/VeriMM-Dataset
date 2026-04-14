`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [209:0] in;
    reg ready;
    reg received;
    wire Rdy;
    wire [79:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .ready(ready),
        .received(received),
        .Rdy(Rdy),
        .out(out)
    );
    task reset_handshake;

    begin
        ready = 0;
        received = 1;
        in = 0;
        #10;
        received = 0;
        #10;
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Initial State", test_num);
        reset_handshake();
        #1;

        check_outputs(0, 80'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: All Segments Zero", test_num);
        reset_handshake();
        in = 210'h0;
        ready = 1;
        #10;
        #1;

        check_outputs(1, 80'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Threshold Boundary (127)", test_num);
        reset_handshake();
        in = {10{21'd127}};
        ready = 1;
        #10;
        #1;

        check_outputs(1, {10{8'h7F}});
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Saturation Boundary (128)", test_num);
        reset_handshake();
        in = {10{21'd128}};
        ready = 1;
        #10;
        #1;

        check_outputs(1, {10{8'h7F}});
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Maximum Bit Values (Saturation)", test_num);
        reset_handshake();
        in = {10{21'h1FFFFF}};
        ready = 1;
        #10;
        #1;

        check_outputs(1, {10{8'h7F}});
    end
        endtask

    task testcase006;

        reg [7:0] o0, o1, o2, o3, o4, o5, o6, o7, o8, o9;
    begin
        test_num = 6;
        $display("\nTestcase %03d: Mixed Segment Values", test_num);
        reset_handshake();

        in = {21'd50, 21'd40, 21'd30, 21'd20, 21'd10, 21'd129, 21'd128, 21'd127, 21'd1, 21'd0};
        o0=8'h32; o1=8'h28; o2=8'h1E; o3=8'h14; o4=8'h0A; o5=8'h7F; o6=8'h7F; o7=8'h7F; o8=8'h01; o9=8'h00;

        ready = 1;
        #10;

        #1;


        check_outputs(1, {o9, o8, o7, o6, o5, o4, o3, o2, o1, o0});
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %03d: Handshake Received Reset", test_num);
        reset_handshake();
        in = {10{21'd64}};
        ready = 1;
        #10;

        if (Rdy !== 1) $display("  Error: Rdy did not assert");

        ready = 0;
        received = 1;
        #10;
        received = 0;

        #1;


        check_outputs(0, {10{8'h40}});
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %03d: Lower 8-bit Check vs Saturation", test_num);
        reset_handshake();

        in = {5{21'd255, 21'd100}};
        ready = 1;
        #10;
        #1;

        check_outputs(1, {5{8'h64, 8'h7F}});
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
        input expected_Rdy;
        input [79:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Rdy === (expected_Rdy ^ Rdy ^ expected_Rdy) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: Rdy=%b, out=%h",
                         Rdy, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Rdy=%b, out=%h",
                         expected_Rdy, expected_out);
                $display("  Got:      Rdy=%b, out=%h",
                         Rdy, out);
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
