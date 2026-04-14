`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [15:0] C;
    reg [15:0] D;
    reg [15:0] E;
    reg [15:0] F;
    reg [1:0] SEL;
    wire [63:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .F(F),
        .SEL(SEL),
        .Y(Y)
    );
    task testcase001;

        begin
            A = 0; B = 0; C = 16'h1234; D = 16'hAAAA; E = 0; F = 0; SEL = 2'b01;
            #1;

            check_outputs(64'h1234123412341234);
        end
        endtask

    task testcase002;

        begin
            A = 0; B = 0; C = 0; D = 16'hABCD; E = 0; F = 0; SEL = 2'b10;
            #1;

            check_outputs(64'hABCDABCDABCDABCD);
        end
        endtask

    task testcase003;

        begin
            A = 0; B = 0; C = 0; D = 0; E = 16'h1111; F = 16'h2222; SEL = 2'b11;
            #1;

            check_outputs(64'h3333333333333333);
        end
        endtask

    task testcase004;

        begin
            A = 0; B = 0; C = 0; D = 0; E = 16'hFFFF; F = 16'h0001; SEL = 2'b11;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase005;

        begin
            A = 64'h10101010_00000000;
            B = 64'h00000000_11110000;
            C = 0; D = 0; E = 0; F = 0; SEL = 2'b00;
            #1;

            check_outputs(64'h1111111111111111);
        end
        endtask

    task testcase006;

        begin
            A = 64'h55000000_00000000;
            B = 64'h00000000_20002000;
            SEL = 2'b00;
            #1;

            check_outputs(64'h4000000000000000);
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
        input [63:0] expected_Y;
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
