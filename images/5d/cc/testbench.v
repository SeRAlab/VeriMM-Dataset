`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i_data0;
    wire [31:0] o_data0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data0(i_data0),
        .o_data0(o_data0)
    );
    task testcase001;

        begin
            test_num = 1;
            i_data0 = 32'd0;
            $display("Test %0d: Input = %d", test_num, i_data0);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            i_data0 = 32'd1;
            $display("Test %0d: Input = %d", test_num, i_data0);
            #1;

            check_outputs(32'd548);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            i_data0 = 32'd10;
            $display("Test %0d: Input = %d", test_num, i_data0);
            #1;

            check_outputs(32'd5480);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            i_data0 = 32'd1000;
            $display("Test %0d: Input = %d", test_num, i_data0);
            #1;

            check_outputs(32'd548000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            i_data0 = 32'h00010000;
            $display("Test %0d: Input = %h", test_num, i_data0);

            #1;


            check_outputs(32'h02240000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            i_data0 = 32'hFFFFFFFF;
            $display("Test %0d: Input = %h", test_num, i_data0);

            #1;


            check_outputs(32'hFFFFFDDC);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            i_data0 = 32'd1234567;
            $display("Test %0d: Input = %d", test_num, i_data0);

            #1;


            check_outputs(32'd676542716);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            i_data0 = 32'h08000000;
            $display("Test %0d: Input = %h", test_num, i_data0);





            #1;






            check_outputs(32'h20000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            i_data0 = 32'hDEADBEEF;
            $display("Test %0d: Input = %h", test_num, i_data0);


            #1;



            check_outputs(32'hA8A0179C);
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
        input [31:0] expected_o_data0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data0 === (expected_o_data0 ^ o_data0 ^ expected_o_data0)) begin
                $display("PASS");
                $display("  Outputs: o_data0=%h",
                         o_data0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data0=%h",
                         expected_o_data0);
                $display("  Got:      o_data0=%h",
                         o_data0);
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
