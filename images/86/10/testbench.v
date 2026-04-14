`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in0;
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    reg [31:0] in4;
    reg [31:0] in5;
    reg [31:0] in6;
    reg s0;
    reg s1;
    reg s2;
    reg s3;
    reg s4;
    reg s5;
    reg s6;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .s0(s0),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .s4(s4),
        .s5(s5),
        .s6(s6),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in0 = 32'hAAAA_AAAA; in1 = 32'h0; in2 = 32'h0; in3 = 32'h0; in4 = 32'h0; in5 = 32'h0; in6 = 32'h0;
            s0 = 1; s1 = 0; s2 = 0; s3 = 0; s4 = 0; s5 = 0; s6 = 0;
            #10;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in0 = 32'h0; in1 = 32'hBBBB_BBBB; in2 = 32'h0; in3 = 32'h0; in4 = 32'h0; in5 = 32'h0; in6 = 32'h0;
            s0 = 0; s1 = 1; s2 = 0; s3 = 0; s4 = 0; s5 = 0; s6 = 0;
            #10;
            #1;

            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in0 = 32'h1111_1111; in1 = 32'h2222_2222; in2 = 32'h3333_3333; in3 = 32'h4444_4444;
            in4 = 32'h5555_5555; in5 = 32'h6666_6666; in6 = 32'h7777_7777;
            s0 = 0; s1 = 0; s2 = 1; s3 = 0; s4 = 0; s5 = 0; s6 = 0;
            #10;
            #1;

            check_outputs(32'h3333_3333);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in3 = 32'hDEAD_BEEF;
            s0 = 0; s1 = 0; s2 = 0; s3 = 1; s4 = 0; s5 = 0; s6 = 0;
            #10;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in4 = 32'hCAFE_BABE;
            s0 = 0; s1 = 0; s2 = 0; s3 = 0; s4 = 1; s5 = 0; s6 = 0;
            #10;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in5 = 32'h1234_5678;
            s0 = 0; s1 = 0; s2 = 0; s3 = 0; s4 = 0; s5 = 1; s6 = 0;
            #10;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in6 = 32'hFFFF_0000;
            s0 = 0; s1 = 0; s2 = 0; s3 = 0; s4 = 0; s5 = 0; s6 = 1;
            #10;
            #1;

            check_outputs(32'hFFFF_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;

            in0 = 32'h0000_0000; in1 = 32'hFFFF_FFFF;
            s0 = 1; s1 = 0; s2 = 0; s3 = 0; s4 = 0; s5 = 0; s6 = 0;
            #10;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;

            in6 = 32'hFFFF_FFFF; in5 = 32'h0000_0000;
            s0 = 0; s1 = 0; s2 = 0; s3 = 0; s4 = 0; s5 = 0; s6 = 1;
            #10;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;

            in2 = 32'h5555_5555;
            s0 = 0; s1 = 0; s2 = 1; s3 = 0; s4 = 0; s5 = 0; s6 = 0;
            #5;
            in2 = 32'hAAAA_AAAA;
            #5;
            #1;

            check_outputs(32'hAAAA_AAAA);
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
