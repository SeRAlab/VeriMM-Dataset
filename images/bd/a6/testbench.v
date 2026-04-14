`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg btnD;
    reg btnL;
    reg btnR;
    reg btnU;
    wire [3:0] SSEG_AN;
    wire [7:0] SSEG_CA;
    wire [15:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .btnU(btnU),
        .SSEG_AN(SSEG_AN),
        .SSEG_CA(SSEG_CA),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'd10; B = 8'd2;
        btnU = 0; btnL = 0; btnR = 1; btnD = 0;
        #10;



        #1;




        check_outputs(4'b1110, 8'hC6, 16'h000C);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'd15; B = 8'd5;
        btnU = 0; btnL = 0; btnR = 0; btnD = 1;
        #10;


        #1;



        check_outputs(4'b1110, 8'h88, 16'h000A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'd8; B = 8'd8;
        btnU = 1; btnL = 0; btnR = 0; btnD = 0;
        #10;


        #1;



        check_outputs(4'b1110, 8'hC0, 16'h0040);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'd100; B = 8'd4;
        btnU = 0; btnL = 1; btnR = 0; btnD = 0;
        #10;


        #1;



        check_outputs(4'b1110, 8'h90, 16'h0019);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'hFF; B = 8'h01;
        btnU = 0; btnL = 0; btnR = 1; btnD = 0;
        #10;


        #1;



        check_outputs(4'b1110, 8'hC0, 16'h0100);
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
        input [3:0] expected_SSEG_AN;
        input [7:0] expected_SSEG_CA;
        input [15:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SSEG_AN === (expected_SSEG_AN ^ SSEG_AN ^ expected_SSEG_AN) &&
                expected_SSEG_CA === (expected_SSEG_CA ^ SSEG_CA ^ expected_SSEG_CA) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: SSEG_AN=%h, SSEG_CA=%h, Z=%h",
                         SSEG_AN, SSEG_CA, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SSEG_AN=%h, SSEG_CA=%h, Z=%h",
                         expected_SSEG_AN, expected_SSEG_CA, expected_Z);
                $display("  Got:      SSEG_AN=%h, SSEG_CA=%h, Z=%h",
                         SSEG_AN, SSEG_CA, Z);
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
