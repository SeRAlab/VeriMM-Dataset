`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] h;
    wire [6:0] out_eq;
    wire [6:0] out_nand;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .h(h),
        .out_eq(out_eq),
        .out_nand(out_nand)
    );
    task testcase001;

        begin
            test_num = 1;
            h = 8'h00;
            #1;

            check_outputs(7'b1111111, 7'b1111111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            h = 8'hFF;

            #1;


            check_outputs(7'b1111111, 7'b0000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            h = 8'hAA;

            #1;


            check_outputs(7'b0000000, 7'b1111111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            h = 8'h55;
            #1;

            check_outputs(7'b0000000, 7'b1111111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            h = 8'h0F;



            #1;




            check_outputs(7'h77, 7'h71);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            h = 8'hF0;



            #1;




            check_outputs(7'h77, 7'h1F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            h = 8'hDA;



            #1;




            check_outputs(7'h48, 7'h6F);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            h = 8'h33;



            #1;




            check_outputs(7'h55, 7'h5D);
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
        input [6:0] expected_out_eq;
        input [6:0] expected_out_nand;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_eq === (expected_out_eq ^ out_eq ^ expected_out_eq) &&
                expected_out_nand === (expected_out_nand ^ out_nand ^ expected_out_nand)) begin
                $display("PASS");
                $display("  Outputs: out_eq=%h, out_nand=%h",
                         out_eq, out_nand);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_eq=%h, out_nand=%h",
                         expected_out_eq, expected_out_nand);
                $display("  Got:      out_eq=%h, out_nand=%h",
                         out_eq, out_nand);
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
