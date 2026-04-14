`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [8:0] out_port;
    wire s1_reset_source;
    wire s2_reset_source;
    wire s3_reset_source;
    wire s4_reset_source;
    wire s5_reset_source;
    wire s6_reset_source;
    wire s7_reset_source;
    wire s8_reset_source;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .out_port(out_port),
        .s1_reset_source(s1_reset_source),
        .s2_reset_source(s2_reset_source),
        .s3_reset_source(s3_reset_source),
        .s4_reset_source(s4_reset_source),
        .s5_reset_source(s5_reset_source),
        .s6_reset_source(s6_reset_source),
        .s7_reset_source(s7_reset_source),
        .s8_reset_source(s8_reset_source)
    );
    task testcase001;

        begin
            test_num = 1;
            out_port = 9'b0;
            #10;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            out_port = 9'b0;
            #10;
            out_port = 9'b111111110;
            #10;
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            out_port = 9'b0;
            #10;
            out_port = 9'b000000001;
            #10;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            out_port = 9'b0;
            #10;
            out_port = 9'b000000010;
            #10;
            #1;

            check_outputs(1, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            out_port = 9'b0;
            #10;
            out_port = 9'b100000000;
            #10;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            out_port = 9'b0;
            #10;


            out_port = 9'b010101010;
            #10;
            #1;

            check_outputs(1, 0, 1, 0, 1, 0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            out_port = 9'b0;
            #10;


            out_port = 9'b101010101;
            #10;
            #1;

            check_outputs(0, 1, 0, 1, 0, 1, 0, 1);
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
        input expected_s1_reset_source;
        input expected_s2_reset_source;
        input expected_s3_reset_source;
        input expected_s4_reset_source;
        input expected_s5_reset_source;
        input expected_s6_reset_source;
        input expected_s7_reset_source;
        input expected_s8_reset_source;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s1_reset_source === (expected_s1_reset_source ^ s1_reset_source ^ expected_s1_reset_source) &&
                expected_s2_reset_source === (expected_s2_reset_source ^ s2_reset_source ^ expected_s2_reset_source) &&
                expected_s3_reset_source === (expected_s3_reset_source ^ s3_reset_source ^ expected_s3_reset_source) &&
                expected_s4_reset_source === (expected_s4_reset_source ^ s4_reset_source ^ expected_s4_reset_source) &&
                expected_s5_reset_source === (expected_s5_reset_source ^ s5_reset_source ^ expected_s5_reset_source) &&
                expected_s6_reset_source === (expected_s6_reset_source ^ s6_reset_source ^ expected_s6_reset_source) &&
                expected_s7_reset_source === (expected_s7_reset_source ^ s7_reset_source ^ expected_s7_reset_source) &&
                expected_s8_reset_source === (expected_s8_reset_source ^ s8_reset_source ^ expected_s8_reset_source)) begin
                $display("PASS");
                $display("  Outputs: s1_reset_source=%b, s2_reset_source=%b, s3_reset_source=%b, s4_reset_source=%b, s5_reset_source=%b, s6_reset_source=%b, s7_reset_source=%b, s8_reset_source=%b",
                         s1_reset_source, s2_reset_source, s3_reset_source, s4_reset_source, s5_reset_source, s6_reset_source, s7_reset_source, s8_reset_source);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s1_reset_source=%b, s2_reset_source=%b, s3_reset_source=%b, s4_reset_source=%b, s5_reset_source=%b, s6_reset_source=%b, s7_reset_source=%b, s8_reset_source=%b",
                         expected_s1_reset_source, expected_s2_reset_source, expected_s3_reset_source, expected_s4_reset_source, expected_s5_reset_source, expected_s6_reset_source, expected_s7_reset_source, expected_s8_reset_source);
                $display("  Got:      s1_reset_source=%b, s2_reset_source=%b, s3_reset_source=%b, s4_reset_source=%b, s5_reset_source=%b, s6_reset_source=%b, s7_reset_source=%b, s8_reset_source=%b",
                         s1_reset_source, s2_reset_source, s3_reset_source, s4_reset_source, s5_reset_source, s6_reset_source, s7_reset_source, s8_reset_source);
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
