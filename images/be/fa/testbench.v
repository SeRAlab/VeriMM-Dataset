`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] y0;
    reg [31:0] y1;
    reg [31:0] y2;
    reg [31:0] y3;
    wire [31:0] z0;
    wire [31:0] z1;
    wire [31:0] z2;
    wire [31:0] z3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .z0(z0),
        .z1(z1),
        .z2(z2),
        .z3(z3)
    );
    task testcase001;

    begin
        $display("Test Case 001: All Zeros");
        test_num = 1;
        y0 = 32'h00000000;
        y1 = 32'h00000000;
        y2 = 32'h00000000;
        y3 = 32'h00000000;
        #1;

        check_outputs(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Single bit at y1");
        test_num = 2;
        y0 = 32'h00000000;
        y1 = 32'h00000001;
        y2 = 32'h00000000;
        y3 = 32'h00000000;




        #1;





        check_outputs(32'h88000100, 32'h00000001, 32'h00000200, 32'h00402000);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Single bit at y0");
        test_num = 3;
        y0 = 32'h00000001;
        y1 = 32'h00000000;
        y2 = 32'h00000000;
        y3 = 32'h00000000;




        #1;





        check_outputs(32'h40808145, 32'h00000080, 32'h00010200, 32'h20500000);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Single bit at y3");
        test_num = 4;
        y0 = 32'h00000000;
        y1 = 32'h00000000;
        y2 = 32'h00000000;
        y3 = 32'h00000001;




        #1;





        check_outputs(32'h40042011, 32'h00000080, 32'h00010000, 32'h20100001);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Alternating bits (0x55...)");
        test_num = 5;
        y0 = 32'h55555555;
        y1 = 32'h55555555;
        y2 = 32'h55555555;
        y3 = 32'h55555555;




        #1;





        check_outputs(32'hff33ffff, 32'hffffffff, 32'hffffffff, 32'haaaaaaaa);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Sequential Pattern");
        test_num = 6;
        y0 = 32'h01234567;
        y1 = 32'h89abcdef;
        y2 = 32'hfedcba98;
        y3 = 32'h76543210;




        #1;





        check_outputs(32'hc8cfab91, 32'h3216d654, 32'h999fccfe, 32'ha23fe57d);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: All Ones");
        test_num = 7;
        y0 = 32'hffffffff;
        y1 = 32'hffffffff;
        y2 = 32'hffffffff;
        y3 = 32'hffffffff;





        #1;






        check_outputs(32'hf8039577, 32'h00000080, 32'hffff01ff, 32'h1fae0000);
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
        input [31:0] expected_z0;
        input [31:0] expected_z1;
        input [31:0] expected_z2;
        input [31:0] expected_z3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z0 === (expected_z0 ^ z0 ^ expected_z0) &&
                expected_z1 === (expected_z1 ^ z1 ^ expected_z1) &&
                expected_z2 === (expected_z2 ^ z2 ^ expected_z2) &&
                expected_z3 === (expected_z3 ^ z3 ^ expected_z3)) begin
                $display("PASS");
                $display("  Outputs: z0=%h, z1=%h, z2=%h, z3=%h",
                         z0, z1, z2, z3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z0=%h, z1=%h, z2=%h, z3=%h",
                         expected_z0, expected_z1, expected_z2, expected_z3);
                $display("  Got:      z0=%h, z1=%h, z2=%h, z3=%h",
                         z0, z1, z2, z3);
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
