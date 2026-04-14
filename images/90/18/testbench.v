`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire [63:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .product(product)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 64'h0;
            B = 64'h0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = IDENTITY;
            B = IDENTITY;
            #1;

            check_outputs(IDENTITY);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 64'h0123_4567_89AB_CDEF;
            B = IDENTITY;
            #1;

            check_outputs(64'h0123_4567_89AB_CDEF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 64'h1111_1111_1111_1111;
            B = 64'h1111_1111_1111_1111;
            #1;

            check_outputs(64'h4444_4444_4444_4444);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 64'h2222_2222_2222_2222;
            B = 64'h3333_3333_3333_3333;
            #1;

            check_outputs(64'h8888_8888_8888_8888);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'h1111_1111_1111_1111;
            #1;

            check_outputs(64'hCCCC_CCCC_CCCC_CCCC);
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
        input [63:0] expected_product;
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
