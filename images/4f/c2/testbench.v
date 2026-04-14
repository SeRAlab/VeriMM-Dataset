`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] p1x;
    reg [10:0] p1y;
    reg [10:0] p2x;
    reg [10:0] p2y;
    reg [10:0] p3x;
    reg [10:0] p3y;
    wire result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p1x(p1x),
        .p1y(p1y),
        .p2x(p2x),
        .p2y(p2y),
        .p3x(p3x),
        .p3y(p3y),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Counter-Clockwise Orientation", test_num);

            p1x = 11'd2; p1y = 11'd1;
            p2x = 11'd1; p2y = 11'd2;
            p3x = 11'd0; p3y = 11'd0;



            #1;




            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Clockwise Orientation", test_num);

            p1x = 11'd1; p1y = 11'd2;
            p2x = 11'd2; p2y = 11'd1;
            p3x = 11'd0; p3y = 11'd0;



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Collinear Points", test_num);

            p1x = 11'd1; p1y = 11'd1;
            p2x = 11'd2; p2y = 11'd2;
            p3x = 11'd0; p3y = 11'd0;



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Coordinates (Signed Logic)", test_num);


            p1x = 11'sh7FB; p1y = 11'sh7FB;
            p2x = 11'sh7F6; p2y = 11'sh7FB;
            p3x = 11'sh7FB; p3y = 11'sh7F6;







            #1;








            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Points Overlapping", test_num);
            p1x = 11'd50; p1y = 11'd50;
            p2x = 11'd50; p2y = 11'd50;
            p3x = 11'd50; p3y = 11'd50;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Difference Signed Products", test_num);


            p1x = 11'sd1023;  p1y = -11'sd1024;
            p2x = -11'sd1024; p2y = 11'sd1023;
            p3x = -11'sd1024; p3y = -11'sd1024;





            #1;






            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vertical Alignment", test_num);
            p1x = 11'd10; p1y = 11'd20;
            p2x = 11'd10; p2y = 11'd30;
            p3x = 11'd10; p3y = 11'd10;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Points far on negative axes", test_num);

            p1x = -11'sd10; p1y = 11'sd0;
            p2x = 11'sd0;   p2y = -11'sd10;
            p3x = 11'sd0;   p3y = 11'sd0;




            #1;





            check_outputs(1'b1);
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
        input expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%b",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%b",
                         expected_result);
                $display("  Got:      result=%b",
                         result);
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
