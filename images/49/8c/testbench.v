`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in_cell;
    reg x;
    wire [7:0] out_cell;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_cell(in_cell),
        .x(x),
        .out_cell(out_cell)
    );
    task testcase001;

    begin
        test_num = 1;
        x = 1'b0;
        in_cell = 8'h00;


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x = 1'b0;
        in_cell = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x = 1'b0;
        in_cell = 8'hAA;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x = 1'b0;
        in_cell = 8'h55;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x = 1'b1;
        in_cell = 8'h00;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x = 1'b1;
        in_cell = 8'hFF;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        x = 1'b0;
        in_cell = 8'h80;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        x = 1'b1;
        in_cell = 8'h01;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        x = 1'b0;
        in_cell = 8'hF0;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        x = 1'b1;
        in_cell = 8'h0F;
        #1;

        check_outputs(8'h1F);
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
        input [7:0] expected_out_cell;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_cell === (expected_out_cell ^ out_cell ^ expected_out_cell)) begin
                $display("PASS");
                $display("  Outputs: out_cell=%h",
                         out_cell);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_cell=%h",
                         expected_out_cell);
                $display("  Got:      out_cell=%h",
                         out_cell);
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
