`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLOCK_50;
    reg [18:0] FB_ADDR;
    reg [7:0] IM_DATA;
    reg [9:0] OBJ_X;
    reg [9:0] OBJ_Y;
    reg RESET;
    wire [7:0] FB_DATA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK_50(CLOCK_50),
        .FB_ADDR(FB_ADDR),
        .IM_DATA(IM_DATA),
        .OBJ_X(OBJ_X),
        .OBJ_Y(OBJ_Y),
        .RESET(RESET),
        .FB_DATA(FB_DATA)
    );
    task testcase001;

        begin
            test_num = 1;

            RESET = 1;
            CLOCK_50 = 0;
            #10 RESET = 0;


            OBJ_X = 10'd100;
            OBJ_Y = 10'd50;
            IM_DATA = 8'hAA;
            FB_ADDR = 19'd0;

            #20;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            RESET = 1;
            #10 RESET = 0;


            OBJ_X = 10'd100;
            OBJ_Y = 10'd50;
            IM_DATA = 8'hBB;
            FB_ADDR = 19'd32100;

            #20;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            RESET = 1;
            #10 RESET = 0;


            OBJ_X = 10'd200;
            OBJ_Y = 10'd200;
            IM_DATA = 8'hCC;
            FB_ADDR = 19'd128201;

            #20;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            RESET = 1;
            #10 RESET = 0;

            OBJ_X = 10'd200;
            OBJ_Y = 10'd200;
            IM_DATA = 8'hDD;
            FB_ADDR = 19'd128207;

            #20;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            RESET = 1;
            #10 RESET = 0;

            OBJ_X = 10'd200;
            OBJ_Y = 10'd200;
            IM_DATA = 8'hEE;
            FB_ADDR = 19'd128208;

            #20;

            #1;


            check_outputs(8'hEE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            RESET = 1;
            #10 RESET = 0;


            OBJ_X = 10'd0;
            OBJ_Y = 10'd0;
            IM_DATA = 8'h11;
            FB_ADDR = 19'd0;

            #20;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            RESET = 1;
            #10 RESET = 0;


            OBJ_X = 10'd630;
            OBJ_Y = 10'd400;
            IM_DATA = 8'h55;
            FB_ADDR = 19'd256630;

            #20;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            RESET = 1;
            #10 RESET = 0;



            OBJ_X = 10'd630;
            OBJ_Y = 10'd400;
            IM_DATA = 8'h77;
            FB_ADDR = 19'd256629;

            #20;

            #1;


            check_outputs(8'h77);
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
        input [7:0] expected_FB_DATA;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_FB_DATA === (expected_FB_DATA ^ FB_DATA ^ expected_FB_DATA)) begin
                $display("PASS");
                $display("  Outputs: FB_DATA=%h",
                         FB_DATA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FB_DATA=%h",
                         expected_FB_DATA);
                $display("  Got:      FB_DATA=%h",
                         FB_DATA);
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
