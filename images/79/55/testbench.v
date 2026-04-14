`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            in1 = 32'h00000000;
            in2 = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones", test_num);
            in1 = 32'hFFFFFFFF;
            in2 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (complementary patterns)", test_num);
            in1 = 32'hAAAAAAAA;
            in2 = 32'h55555555;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: OR with zero (Identity property)", test_num);
            in1 = 32'h12345678;
            in2 = 32'h00000000;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: OR with FFFF (Saturation property)", test_num);
            in1 = 32'hABCDEF01;
            in2 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit set in each", test_num);
            in1 = 32'h00000001;
            in2 = 32'h80000000;
            #1;

            check_outputs(32'h80000001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern 1", test_num);
            in1 = 32'hF0F0F0F0;
            in2 = 32'h0F0F0F0F;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern 2", test_num);
            in1 = 32'hCC33CC33;
            in2 = 32'hAA55AA55;


            #1;



            check_outputs(32'hEE77EE77);
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
