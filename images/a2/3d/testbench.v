`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EN;
    reg [3:0] SEL;
    reg [7:0] data_in;
    reg [2:0] shift_amount;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .SEL(SEL),
        .data_in(data_in),
        .shift_amount(shift_amount),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;

        EN = 0; data_in = 8'h0; shift_amount = 3'h0; SEL = 4'h0;
        #10;

        data_in = 8'hFF; shift_amount = 3'h4; SEL = 4'hF; EN = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        EN = 0; data_in = 8'h0; shift_amount = 3'h0; SEL = 4'h0;
        #10;


        data_in = 8'hA5; shift_amount = 3'h0; SEL = 4'hF; EN = 1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        EN = 0; data_in = 8'h0; shift_amount = 3'h0; SEL = 4'h0;
        #10;


        data_in = 8'h55; shift_amount = 3'h1; SEL = 4'hF; EN = 1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        EN = 0; data_in = 8'h0; shift_amount = 3'h0; SEL = 4'h0;
        #10;


        data_in = 8'hA5; shift_amount = 3'h4; SEL = 4'hF; EN = 1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        EN = 0; data_in = 8'h0; shift_amount = 3'h0; SEL = 4'h0;
        #10;


        data_in = 8'hFF; shift_amount = 3'h0; SEL = 4'hA; EN = 1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        EN = 0; data_in = 8'h0; shift_amount = 3'h0; SEL = 4'h0;
        #10;


        data_in = 8'h80; shift_amount = 3'h1; SEL = 4'hF; EN = 1;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        EN = 0; data_in = 8'h0; shift_amount = 3'h0; SEL = 4'h0;
        #10;


        data_in = 8'h11; shift_amount = 3'h7; SEL = 4'hF; EN = 1;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        EN = 0; data_in = 8'h0; shift_amount = 3'h0; SEL = 4'h0;
        #10;


        data_in = 8'h33; shift_amount = 3'h4; SEL = 4'h1; EN = 1;
        #1;

        check_outputs(4'h1);
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
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
