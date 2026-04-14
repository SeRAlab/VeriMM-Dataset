`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'd0; b = 8'd0;
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'sd10; b = 8'sd5;
            #1;

            check_outputs(16'sd50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'sd10; b = -8'sd5;
            #1;

            check_outputs(-16'sd50);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = -8'sd10; b = 8'sd5;
            #1;

            check_outputs(-16'sd50);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = -8'sd10; b = -8'sd5;
            #1;

            check_outputs(16'sd50);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'sb01111111;
            b = 8'sb01111111;
            #1;

            check_outputs(16'sd16129);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 8'sb10000000;
            b = 8'sb01111111;
            #1;

            check_outputs(-16'sd16256);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 8'sb10000000;
            b = 8'sb10000000;
            #1;

            check_outputs(16'sd16384);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 8'sd1; b = -8'sd128;
            #1;

            check_outputs(-16'sd128);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = -8'sd1; b = -8'sd1;
            #1;

            check_outputs(16'sd1);
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
        input [15:0] expected_product;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
