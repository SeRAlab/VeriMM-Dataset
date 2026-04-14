`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] x;
    wire [8:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        x = 9'h000;
        #10;
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x = 9'h001;
        #10;


        #1;



        check_outputs(9'h002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x = 9'h002;
        #10;
        #1;

        check_outputs(9'h004);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x = 9'h07F;
        #10;
        #1;

        check_outputs(9'h0FE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x = 9'h080;
        #10;
        #1;

        check_outputs(9'h100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x = 9'h100;
        #10;



        #1;




        check_outputs(9'h11D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        x = 9'h0AA;
        #10;
        #1;

        check_outputs(9'h154);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        x = 9'h155;
        #10;

        #1;


        check_outputs(9'h1B7);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        x = 9'h0FF;
        #10;
        #1;

        check_outputs(9'h1FE);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        x = 9'h1FF;
        #10;

        #1;


        check_outputs(9'h0E3);
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
        input [8:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
