`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Y(Y)
    );
    task testcase001;

    begin
        $display("\nRunning testcase001: Zero and Identity Properties");
        A = 8'd0; B = 8'd0; #1;
 check_outputs(16'd0);
        A = 8'd255; B = 8'd0; #1;
 check_outputs(16'd0);
        A = 8'd0; B = 8'd128; #1;
 check_outputs(16'd0);
        A = 8'd1; B = 8'd1; #1;
 check_outputs(16'd1);
        A = 8'd255; B = 8'd1; #1;
 check_outputs(16'd255);
        A = 8'd1; B = 8'd127; #1;
 check_outputs(16'd127);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Maximum and Boundary Values");
        A = 8'd255; B = 8'd255; #1;
 check_outputs(16'd65025);
        A = 8'd255; B = 8'd2;   #1;
   check_outputs(16'd510);
        A = 8'd128; B = 8'd128; #1;
 check_outputs(16'd16384);
        A = 8'd254; B = 8'd254; #1;
 check_outputs(16'd64516);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Powers of 2");
        A = 8'd2; B = 8'd4; #1;
 check_outputs(16'd8);
        A = 8'd16; B = 8'd16; #1;
 check_outputs(16'd256);
        A = 8'd64; B = 8'd2; #1;
 check_outputs(16'd128);
        A = 8'd128; B = 8'd1; #1;
 check_outputs(16'd128);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Alternating Bit Patterns");
        A = 8'hAA; B = 8'h55; #1;
 check_outputs(16'hAA * 16'h55);
        A = 8'hFF; B = 8'h0F; #1;
 check_outputs(16'd255 * 16'd15);
        A = 8'h55; B = 8'h55; #1;
 check_outputs(16'd85 * 16'd85);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Arbitrary Values");
        A = 8'd13; B = 8'd7; #1;
 check_outputs(16'd91);
        A = 8'd123; B = 8'd45; #1;
 check_outputs(16'd5535);
        A = 8'd19; B = 8'd71; #1;
 check_outputs(16'd1349);
        A = 8'd99; B = 8'd99; #1;
 check_outputs(16'd9801);
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
        input [15:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
