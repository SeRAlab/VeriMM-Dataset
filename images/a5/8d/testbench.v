`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in0;
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    reg s0;
    reg s1;
    reg s2;
    reg s3;
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
        .s0(s0),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select in0 (s0=1)", test_num);
            in0 = 32'hDEADBEEF;
            in1 = 32'hCAFEBABE;
            in2 = 32'hBAADF00D;
            in3 = 32'hFEEDFACE;
            s0 = 1; s1 = 0; s2 = 0; s3 = 0;
            #10;
            #1;

            check_outputs(in0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select in1 (s1=1)", test_num);
            in0 = 32'h00001111;
            in1 = 32'h22223333;
            in2 = 32'h44445555;
            in3 = 32'h66667777;
            s0 = 0; s1 = 1; s2 = 0; s3 = 0;
            #10;
            #1;

            check_outputs(in1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select in2 (s2=1)", test_num);
            in0 = 32'hAAAAAAAA;
            in1 = 32'h55555555;
            in2 = 32'hCCCCCCCC;
            in3 = 32'h33333333;
            s0 = 0; s1 = 0; s2 = 1; s3 = 0;
            #10;
            #1;

            check_outputs(in2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select in3 (s3=1)", test_num);
            in0 = 32'hFFFFFFFF;
            in1 = 32'h00000000;
            in2 = 32'h12345678;
            in3 = 32'h87654321;
            s0 = 0; s1 = 0; s2 = 0; s3 = 1;
            #10;
            #1;

            check_outputs(in3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: No select active (Expect Unknown)", test_num);
            in0 = 32'h11111111;
            in1 = 32'h22222222;
            in2 = 32'h33333333;
            in3 = 32'h44444444;
            s0 = 0; s1 = 0; s2 = 0; s3 = 0;
            #10;
            #1;

            check_outputs(32'hXXXXXXXX);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Switching select from s0 to s3", test_num);
            in0 = 32'hA5A5A5A5;
            in3 = 32'h5A5A5A5A;
            s0 = 1; s1 = 0; s2 = 0; s3 = 0;
            #5;
            s0 = 0; s3 = 1;
            #5;
            #1;

            check_outputs(in3);
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
