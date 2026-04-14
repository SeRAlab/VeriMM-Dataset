`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] gps_in;
    wire [31:0] pos;
    wire [31:0] vel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .gps_in(gps_in),
        .pos(pos),
        .vel(vel)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: All Inputs Zero", test_num);
        gps_in = 4'b0000;

        #1;


        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Signal Bit 0 Active", test_num);
        gps_in = 4'b0001;

        #1;


        check_outputs(32'hAAAA_AAAA, 32'h0000_0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: All Signals Active", test_num);
        gps_in = 4'b1111;

        #1;


        check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Pattern 1010", test_num);
        gps_in = 4'b1010;
        #1;

        check_outputs(32'h1234_5678, 32'h8765_4321);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Pattern 0101", test_num);
        gps_in = 4'b0101;
        #1;

        check_outputs(32'hCAFE_BABE, 32'hDEAD_BEEF);
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
        input [31:0] expected_pos;
        input [31:0] expected_vel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pos === (expected_pos ^ pos ^ expected_pos) &&
                expected_vel === (expected_vel ^ vel ^ expected_vel)) begin
                $display("PASS");
                $display("  Outputs: pos=%h, vel=%h",
                         pos, vel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h, vel=%h",
                         expected_pos, expected_vel);
                $display("  Got:      pos=%h, vel=%h",
                         pos, vel);
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
