`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] hpos_one;
    reg [8:0] hpos_two;
    reg [8:0] vpos_one;
    reg [8:0] vpos_two;
    wire [1:0] flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hpos_one(hpos_one),
        .hpos_two(hpos_two),
        .vpos_one(vpos_one),
        .vpos_two(vpos_two),
        .flag(flag)
    );
    task testcase001;

    begin
        test_num = 1;
        hpos_one = 9'd100; vpos_one = 9'd100;
        hpos_two = 9'd200; vpos_two = 9'd200;

        #1;


        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        hpos_one = 9'd100; vpos_one = 9'd100;
        hpos_two = 9'd110; vpos_two = 9'd200;

        #1;


        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        hpos_one = 9'd100; vpos_one = 9'd100;
        hpos_two = 9'd200; vpos_two = 9'd110;

        #1;


        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        hpos_one = 9'd100; vpos_one = 9'd100;
        hpos_two = 9'd105; vpos_two = 9'd105;

        #1;


        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        hpos_one = 9'd100; vpos_one = 9'd100;
        hpos_two = 9'd124; vpos_two = 9'd124;

        #1;


        check_outputs(2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        hpos_one = 9'd100; vpos_one = 9'd100;
        hpos_two = 9'd125; vpos_two = 9'd125;

        #1;


        check_outputs(2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        hpos_one = 9'd50; vpos_one = 9'd50;
        hpos_two = 9'd50; vpos_two = 9'd50;

        #1;


        check_outputs(2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        hpos_one = 9'd100; vpos_one = 9'd100;
        hpos_two = 9'd80;  vpos_two = 9'd80;

        #1;


        check_outputs(2'b11);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        hpos_one = 9'd100; vpos_one = 9'd100;
        hpos_two = 9'd76;  vpos_two = 9'd200;

        #1;


        check_outputs(2'b01);
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
        input [1:0] expected_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_flag === (expected_flag ^ flag ^ expected_flag)) begin
                $display("PASS");
                $display("  Outputs: flag=%h",
                         flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flag=%h",
                         expected_flag);
                $display("  Got:      flag=%h",
                         flag);
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
