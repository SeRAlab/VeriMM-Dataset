`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] d;
    wire [31:0] a;
    wire p_lost;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .a(a),
        .p_lost(p_lost)
    );
    task testcase001;

        begin
            test_num = 1;
            d = 32'h00000000;
            #1;

            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            d = 32'd1;
            #1;

            check_outputs(32'h3F800000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            d = -32'd1;
            #1;

            check_outputs(32'hBF800000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            d = 32'd10;
            #1;

            check_outputs(32'h41200000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            d = -32'd10;
            #1;

            check_outputs(32'hC1200000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            d = 32'h00800000;
            #1;

            check_outputs(32'h4B000000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;



            d = 32'd16777217;
            #1;

            check_outputs(32'h4B800000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            d = 32'h7FFFFFFF;


            #1;



            check_outputs(32'h4E7FFFFF, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            d = 32'h80000000;

            #1;


            check_outputs(32'hCF000000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            d = 32'h00FFFFFF;


            #1;



            check_outputs(32'h4B7FFFFF, 1'b0);
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
        input [31:0] expected_a;
        input expected_p_lost;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_p_lost === (expected_p_lost ^ p_lost ^ expected_p_lost)) begin
                $display("PASS");
                $display("  Outputs: a=%h, p_lost=%b",
                         a, p_lost);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h, p_lost=%b",
                         expected_a, expected_p_lost);
                $display("  Got:      a=%h, p_lost=%b",
                         a, p_lost);
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
