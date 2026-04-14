`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [6:0] out_equal;
    wire [6:0] out_greater;
    wire [7:0] out_wrap;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_equal(out_equal),
        .out_greater(out_greater),
        .out_wrap(out_wrap)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in = 8'h00;

            #1;


            check_outputs(7'h7F, 7'h00, 8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in = 8'hFF;

            #1;


            check_outputs(7'h7F, 7'h00, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in = 8'hAA;



            #1;




            check_outputs(7'h00, 7'h55, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in = 8'h55;



            #1;




            check_outputs(7'h00, 7'h2A, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in = 8'h66;




            #1;





            check_outputs(7'h2A, 7'h11, 8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in = 8'hCC;




            #1;





            check_outputs(7'h55, 7'h22, 8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in = 8'h0F;



            #1;




            check_outputs(7'h77, 7'h00, 8'hEE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            in = 8'hF0;



            #1;




            check_outputs(7'h77, 7'h08, 8'hEE);
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
        input [6:0] expected_out_equal;
        input [6:0] expected_out_greater;
        input [7:0] expected_out_wrap;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_equal === (expected_out_equal ^ out_equal ^ expected_out_equal) &&
                expected_out_greater === (expected_out_greater ^ out_greater ^ expected_out_greater) &&
                expected_out_wrap === (expected_out_wrap ^ out_wrap ^ expected_out_wrap)) begin
                $display("PASS");
                $display("  Outputs: out_equal=%h, out_greater=%h, out_wrap=%h",
                         out_equal, out_greater, out_wrap);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_equal=%h, out_greater=%h, out_wrap=%h",
                         expected_out_equal, expected_out_greater, expected_out_wrap);
                $display("  Got:      out_equal=%h, out_greater=%h, out_wrap=%h",
                         out_equal, out_greater, out_wrap);
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
