`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [3:0] in4;
    reg [1:0] sel1;
    reg [1:0] sel2;
    wire [3:0] out1;
    wire [3:0] out2;
    wire [3:0] out3;
    wire [3:0] out4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .sel1(sel1),
        .sel2(sel2),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: All selects set to 0");
            test_num = 1;
            in1 = 4'hA; in2 = 4'hB; in3 = 4'hC; in4 = 4'hD;
            sel1 = 2'b00; sel2 = 2'b00;





            #1;






            check_outputs(4'hA, 4'hC, 4'hA, 4'hC);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: All selects set to 1");
            test_num = 2;
            in1 = 4'h1; in2 = 4'h2; in3 = 4'h3; in4 = 4'h4;
            sel1 = 2'b11; sel2 = 2'b11;





            #1;






            check_outputs(4'h2, 4'h4, 4'h2, 4'h4);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Alternating select bits (Mixed)");
            test_num = 3;
            in1 = 4'hE; in2 = 4'hF; in3 = 4'h0; in4 = 4'h1;
            sel1 = 2'b01;
            sel2 = 2'b10;





            #1;






            check_outputs(4'hF, 4'h0, 4'hE, 4'h1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Inverse of Alternating select bits");
            test_num = 4;
            in1 = 4'h5; in2 = 4'h6; in3 = 4'h7; in4 = 4'h8;
            sel1 = 2'b10;
            sel2 = 2'b01;





            #1;






            check_outputs(4'h5, 4'h8, 4'h6, 4'h7);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Testing maximum input values");
            test_num = 5;
            in1 = 4'hF; in2 = 4'hF; in3 = 4'hF; in4 = 4'hF;
            sel1 = 2'b11; sel2 = 2'b00;

            #1;


            check_outputs(4'hF, 4'hF, 4'hF, 4'hF);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Data independence check");
            test_num = 6;
            in1 = 4'h1; in2 = 4'h2; in3 = 4'h4; in4 = 4'h8;
            sel1 = 2'b11; sel2 = 2'b00;


            #1;



            check_outputs(4'h2, 4'h8, 4'h1, 4'h4);
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
        input [3:0] expected_out1;
        input [3:0] expected_out2;
        input [3:0] expected_out3;
        input [3:0] expected_out4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h, out3=%h, out4=%h",
                         out1, out2, out3, out4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h, out3=%h, out4=%h",
                         expected_out1, expected_out2, expected_out3, expected_out4);
                $display("  Got:      out1=%h, out2=%h, out3=%h, out4=%h",
                         out1, out2, out3, out4);
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
