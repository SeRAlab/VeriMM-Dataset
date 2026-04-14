`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] in;
    wire [7:0] out_any;
    wire [7:0] out_both;
    wire [8:0] out_different;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_any(out_any),
        .out_both(out_both),
        .out_different(out_different)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 9'h000;

            #1;


            check_outputs(8'h00, 8'h00, 9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 9'h1FF;

            #1;


            check_outputs(8'hFF, 8'hFF, 9'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 9'h155;



            #1;




            check_outputs(8'hFF, 8'h00, 9'h0FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 9'h0AA;



            #1;




            check_outputs(8'hFF, 8'h00, 9'h0FF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 9'h001;



            #1;




            check_outputs(8'h01, 8'h00, 9'h101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 9'h100;



            #1;




            check_outputs(8'h80, 8'h00, 9'h180);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 9'h003;



            #1;




            check_outputs(8'h03, 8'h01, 9'h102);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 9'h180;



            #1;




            check_outputs(8'hC0, 8'h80, 9'h140);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 9'h101;



            #1;




            check_outputs(8'h81, 8'h00, 9'h081);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in = 9'h012;




            #1;





            check_outputs(8'h1B, 8'h00, 9'h01B);
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
        input [7:0] expected_out_any;
        input [7:0] expected_out_both;
        input [8:0] expected_out_different;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_any === (expected_out_any ^ out_any ^ expected_out_any) &&
                expected_out_both === (expected_out_both ^ out_both ^ expected_out_both) &&
                expected_out_different === (expected_out_different ^ out_different ^ expected_out_different)) begin
                $display("PASS");
                $display("  Outputs: out_any=%h, out_both=%h, out_different=%h",
                         out_any, out_both, out_different);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_any=%h, out_both=%h, out_different=%h",
                         expected_out_any, expected_out_both, expected_out_different);
                $display("  Got:      out_any=%h, out_both=%h, out_different=%h",
                         out_any, out_both, out_different);
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
