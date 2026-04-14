`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    wire [3:0] result_flags;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .result_flags(result_flags)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Equality Check (10, 10)", test_num);
        in1 = 32'd10;
        in2 = 32'd10;

        #1;


        check_outputs(4'b0100);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Greater Than Check (20, 10)", test_num);
        in1 = 32'd20;
        in2 = 32'd10;

        #1;


        check_outputs(4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Less Than Check (10, 20)", test_num);
        in1 = 32'd10;
        in2 = 32'd20;


        #1;



        check_outputs(4'b1000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unsigned Max vs Zero", test_num);
        in1 = 32'hFFFFFFFF;
        in2 = 32'h00000000;


        #1;



        check_outputs(4'b1010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero vs Unsigned Max", test_num);
        in1 = 32'h00000000;
        in2 = 32'hFFFFFFFF;


        #1;



        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary Equality (0x80000000)", test_num);
        in1 = 32'h80000000;
        in2 = 32'h80000000;

        #1;


        check_outputs(4'b0100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Pos vs Min Neg (0x7FFFFFFF, 0x80000000)", test_num);
        in1 = 32'h7FFFFFFF;
        in2 = 32'h80000000;



        #1;




        check_outputs(4'b1000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min Neg vs Max Pos (0x80000000, 0x7FFFFFFF)", test_num);
        in1 = 32'h80000000;
        in2 = 32'h7FFFFFFF;



        #1;




        check_outputs(4'b0010);
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
        input [3:0] expected_result_flags;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result_flags === (expected_result_flags ^ result_flags ^ expected_result_flags)) begin
                $display("PASS");
                $display("  Outputs: result_flags=%h",
                         result_flags);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_flags=%h",
                         expected_result_flags);
                $display("  Got:      result_flags=%h",
                         result_flags);
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
