`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [1:0] sel;
    reg valid;
    wire equal_to;
    wire greater_than;
    wire less_than;
    wire [1:0] out_mode0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sel(sel),
        .valid(valid),
        .equal_to(equal_to),
        .greater_than(greater_than),
        .less_than(less_than),
        .out_mode0(out_mode0)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A = B, sel = 01 (Active)", test_num);
        valid = 1;
        A = 4'd8;
        B = 4'd8;
        sel = 2'b01;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A > B, sel = 01 (Active)", test_num);
        valid = 1;
        A = 4'd12;
        B = 4'd4;
        sel = 2'b01;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A < B, sel = 01 (Active)", test_num);
        valid = 1;
        A = 4'd3;
        B = 4'd9;
        sel = 2'b01;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A = B, sel = 00 (Deactivated)", test_num);
        valid = 1;
        A = 4'd5;
        B = 4'd5;
        sel = 2'b00;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A > B, sel = 10 (Deactivated)", test_num);
        valid = 1;
        A = 4'd15;
        B = 4'd0;
        sel = 2'b10;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A < B, sel = 11 (Deactivated)", test_num);
        valid = 1;
        A = 4'd1;
        B = 4'd14;
        sel = 2'b11;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=15, B=15, sel = 01 (Max Boundary)", test_num);
        valid = 1;
        A = 4'b1111;
        B = 4'b1111;
        sel = 2'b01;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=0, B=0, sel = 01 (Min Boundary)", test_num);
        valid = 1;
        A = 4'b0000;
        B = 4'b0000;
        sel = 2'b01;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 2'b00);
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
        input expected_equal_to;
        input expected_greater_than;
        input expected_less_than;
        input [1:0] expected_out_mode0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal_to === (expected_equal_to ^ equal_to ^ expected_equal_to) &&
                expected_greater_than === (expected_greater_than ^ greater_than ^ expected_greater_than) &&
                expected_less_than === (expected_less_than ^ less_than ^ expected_less_than) &&
                expected_out_mode0 === (expected_out_mode0 ^ out_mode0 ^ expected_out_mode0)) begin
                $display("PASS");
                $display("  Outputs: equal_to=%b, greater_than=%b, less_than=%b, out_mode0=%h",
                         equal_to, greater_than, less_than, out_mode0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal_to=%b, greater_than=%b, less_than=%b, out_mode0=%h",
                         expected_equal_to, expected_greater_than, expected_less_than, expected_out_mode0);
                $display("  Got:      equal_to=%b, greater_than=%b, less_than=%b, out_mode0=%h",
                         equal_to, greater_than, less_than, out_mode0);
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
