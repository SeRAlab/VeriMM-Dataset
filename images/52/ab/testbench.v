`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    reg [31:0] in4;
    reg [31:0] in5;
    wire [31:0] out;

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
        .in5(in5),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in1 = 32'd1; in2 = 32'd1; in3 = 32'd1; in4 = 32'd1; in5 = 32'd1;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in1 = 32'd500; in2 = 32'd0; in3 = 32'd12345; in4 = 32'd99; in5 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in1 = 32'd2; in2 = 32'd3; in3 = 32'd4; in4 = 32'd5; in5 = 32'd6;

            #1;


            check_outputs(32'd720);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in1 = 32'd1000; in2 = 32'd1000; in3 = 32'd1000; in4 = 32'd1; in5 = 32'd1;

            #1;


            check_outputs(32'd1_000_000_000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in1 = 32'h10000;
            in2 = 32'h10000;
            in3 = 32'd1; in4 = 32'd1; in5 = 32'd1;

            #1;


            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in1 = 32'hFFFFFFFF;
            in2 = 32'd5;
            in3 = 32'd1; in4 = 32'd1; in5 = 32'd1;

            #1;


            check_outputs(32'hFFFFFFFB);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in1 = 32'hFFFFFFFF;
            in2 = 32'hFFFFFFFF;
            in3 = 32'hFFFFFFFF;
            in4 = 32'hFFFFFFFF;
            in5 = 32'hFFFFFFFF;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            in1 = 32'd2; in2 = 32'd4; in3 = 32'd8; in4 = 32'd16; in5 = 32'd32;

            #1;


            check_outputs(32'd32768);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            in1 = 32'h12345678;
            in2 = 32'h87654321;
            in3 = 32'h2;
            in4 = 32'h3;
            in5 = 32'h4;

            #1;


            check_outputs(32'h12345678 * 32'h87654321 * 32'h2 * 32'h3 * 32'h4);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            in1 = 32'd3; in2 = 32'd7; in3 = 32'd11; in4 = 32'd13; in5 = 32'd17;

            #1;


            check_outputs(32'd51051);
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
        input [31:0] expected_out;
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
