`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    wire [31:0] out1;
    wire [31:0] out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out1(out1),
        .out2(out2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            in1 = 16'h0000;
            in2 = 16'h0000;


            #1;



            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Positive Values", test_num);
            in1 = 16'd10;
            in2 = 16'd20;


            #1;



            check_outputs(32'd200, 32'd200);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Unsigned Inputs", test_num);
            in1 = 16'hFFFF;
            in2 = 16'hFFFF;


            #1;



            check_outputs(32'hFFFE0001, 32'h00000001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed Negative * Positive", test_num);
            in1 = 16'hFFFF;
            in2 = 16'h000A;


            #1;



            check_outputs(32'h0009FFF6, 32'hFFFFFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed Positive * Negative", test_num);
            in1 = 16'h0005;
            in2 = 16'hFFFE;


            #1;



            check_outputs(32'h0004FFF6, 32'hFFFFFFF6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed Minimum Value * 2", test_num);
            in1 = 16'h8000;
            in2 = 16'h0002;


            #1;



            check_outputs(32'h00010000, 32'hFFFF0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed Minimum Value * -1", test_num);
            in1 = 16'h8000;
            in2 = 16'hFFFF;


            #1;



            check_outputs(32'h7FFF8000, 32'h00008000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed Max Positive * Max Positive", test_num);
            in1 = 16'h7FFF;
            in2 = 16'h7FFF;


            #1;



            check_outputs(32'h3FFF0001, 32'h3FFF0001);
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
        input [31:0] expected_out1;
        input [31:0] expected_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%h, out2=%h",
                         out1, out2);
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
