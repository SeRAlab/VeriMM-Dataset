`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [27:0] in1;
    reg in2;
    reg in3;
    reg [31:0] in4;
    wire [31:0] out1;

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
        .out1(out1)
    );
    task testcase001;

        begin
            test_num = 1;
            in4 = 32'd0;
            in3 = 1'b0;
            in2 = 1'b0;
            in1 = 28'd0;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in4 = 32'd100;
            in3 = 1'b1;
            in2 = 1'b1;
            in1 = 28'd50;

            #1;


            check_outputs(32'd151);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in4 = 32'd100;
            in3 = 1'b0;
            in2 = 1'b1;
            in1 = 28'd50;

            #1;


            check_outputs(32'd150);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in4 = 32'd100;
            in3 = 1'b1;
            in2 = 1'b1;
            in1 = 28'hFFFFFFF;

            #1;


            check_outputs(32'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in4 = 32'h00000005;
            in3 = 1'b1;
            in2 = 1'b1;
            in1 = 28'hF000000;


            #1;



            check_outputs(32'hFF000006);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in4 = 32'hFFFFFFFF;
            in3 = 1'b1;
            in2 = 1'b1;
            in1 = 28'h0000000;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in4 = 32'h0000000A;
            in3 = 1'b1;
            in2 = 1'b1;
            in1 = 28'h7FFFFFF;

            #1;


            check_outputs(32'h0800000A);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in4 = 32'h10000000;
            in3 = 1'b0;
            in2 = 1'b1;
            in1 = 28'h8000000;


            #1;



            check_outputs(32'h08000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in4 = 32'hFFFFFFFF;
            in3 = 1'b1;
            in2 = 1'b1;
            in1 = 28'h7FFFFFF;

            #1;


            check_outputs(32'h07FFFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in4 = 32'h12345678;
            in3 = 1'b0;
            in2 = 1'b0;
            in1 = 28'hABCDEF0;


            #1;



            check_outputs(32'h0CF13568);
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
        input [31:0] expected_out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out1=%h",
                         out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h",
                         expected_out1);
                $display("  Got:      out1=%h",
                         out1);
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
