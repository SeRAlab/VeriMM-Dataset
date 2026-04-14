`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] address;
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [7:0] in4;
    reg [7:0] in5;
    reg [7:0] in6;
    reg [7:0] in7;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Selecting in0", test_num);
            in0 = 8'hA1; in1 = 8'hB2; in2 = 8'hC3; in3 = 8'hD4;
            in4 = 8'hE5; in5 = 8'hF6; in6 = 8'h07; in7 = 8'h18;
            address = 3'd0;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Selecting in1", test_num);
            in0 = 8'hA1; in1 = 8'hB2; in2 = 8'hC3; in3 = 8'hD4;
            in4 = 8'hE5; in5 = 8'hF6; in6 = 8'h07; in7 = 8'h18;
            address = 3'd1;
            #1;

            check_outputs(8'hB2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Selecting in2", test_num);
            in0 = 8'hA1; in1 = 8'hB2; in2 = 8'hC3; in3 = 8'hD4;
            in4 = 8'hE5; in5 = 8'hF6; in6 = 8'h07; in7 = 8'h18;
            address = 3'd2;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Selecting in3", test_num);
            in0 = 8'hA1; in1 = 8'hB2; in2 = 8'hC3; in3 = 8'hD4;
            in4 = 8'hE5; in5 = 8'hF6; in6 = 8'h07; in7 = 8'h18;
            address = 3'd3;
            #1;

            check_outputs(8'hD4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Selecting in4", test_num);
            in0 = 8'hA1; in1 = 8'hB2; in2 = 8'hC3; in3 = 8'hD4;
            in4 = 8'hE5; in5 = 8'hF6; in6 = 8'h07; in7 = 8'h18;
            address = 3'd4;
            #1;

            check_outputs(8'hE5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Selecting in5", test_num);
            in0 = 8'hA1; in1 = 8'hB2; in2 = 8'hC3; in3 = 8'hD4;
            in4 = 8'hE5; in5 = 8'hF6; in6 = 8'h07; in7 = 8'h18;
            address = 3'd5;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Selecting in6", test_num);
            in0 = 8'hA1; in1 = 8'hB2; in2 = 8'hC3; in3 = 8'hD4;
            in4 = 8'hE5; in5 = 8'hF6; in6 = 8'h07; in7 = 8'h18;
            address = 3'd6;
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Selecting in7", test_num);
            in0 = 8'hA1; in1 = 8'hB2; in2 = 8'hC3; in3 = 8'hD4;
            in4 = 8'hE5; in5 = 8'hF6; in6 = 8'h07; in7 = 8'h18;
            address = 3'd7;
            #1;

            check_outputs(8'h18);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Verification of Inactive Input", test_num);
            address = 3'd0;
            in0 = 8'hFF;
            in1 = 8'h00;
            #5;
            in1 = 8'hAA;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Edge Case All Inputs 0xFF", test_num);
            address = 3'd4;
            in0=8'hFF; in1=8'hFF; in2=8'hFF; in3=8'hFF;
            in4=8'hFF; in5=8'hFF; in6=8'hFF; in7=8'hFF;
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
