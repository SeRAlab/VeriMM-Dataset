`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in_vec;
    wire [7:0] out_vec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_vec(in_vec),
        .out_vec(out_vec)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All zeros (8'h00)", test_num);
            in_vec = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All ones (8'hFF)", test_num);
            in_vec = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: MSB bit set (8'h80 -> 8'h01)", test_num);
            in_vec = 8'h80;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: LSB bit set (8'h01 -> 8'h80)", test_num);
            in_vec = 8'h01;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Alternating bits pattern A (8'hAA -> 8'h55)", test_num);
            in_vec = 8'hAA;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Alternating bits pattern B (8'h55 -> 8'hAA)", test_num);
            in_vec = 8'h55;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Palindrome pattern (8'hC3 -> 8'hC3)", test_num);
            in_vec = 8'hC3;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Mixed pattern (8'hB4 -> 8'h2D)", test_num);
            in_vec = 8'hB4;
            #1;

            check_outputs(8'h2D);
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
        input [7:0] expected_out_vec;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_vec === (expected_out_vec ^ out_vec ^ expected_out_vec)) begin
                $display("PASS");
                $display("  Outputs: out_vec=%h",
                         out_vec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_vec=%h",
                         expected_out_vec);
                $display("  Got:      out_vec=%h",
                         out_vec);
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
