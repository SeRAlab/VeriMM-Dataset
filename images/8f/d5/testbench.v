`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in1;
    reg [3:0] in2;
    wire [1:0] comp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .comp(comp)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Equal (Zero)", test_num);
            in1 = 4'd0;
            in2 = 4'd0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Equal (Non-zero)", test_num);
            in1 = 4'd7;
            in2 = 4'd7;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Equal (Max)", test_num);
            in1 = 4'd15;
            in2 = 4'd15;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: in1 < in2 (Zero vs Max)", test_num);
            in1 = 4'd0;
            in2 = 4'd15;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: in1 < in2 (Small difference)", test_num);
            in1 = 4'd5;
            in2 = 4'd6;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: in1 > in2 (Max vs Zero)", test_num);
            in1 = 4'd15;
            in2 = 4'd0;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest %0d: in1 > in2 (Small difference)", test_num);
            in1 = 4'd10;
            in2 = 4'd9;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest %0d: in1 < in2 (Mid range)", test_num);
            in1 = 4'd3;
            in2 = 4'd12;
            #1;

            check_outputs(2'b01);
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
        input [1:0] expected_comp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_comp === (expected_comp ^ comp ^ expected_comp)) begin
                $display("PASS");
                $display("  Outputs: comp=%h",
                         comp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp=%h",
                         expected_comp);
                $display("  Got:      comp=%h",
                         comp);
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
