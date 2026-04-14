`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] chip_sel;
    reg clk;
    reg [2:0] lane_sel;
    wire [63:0] onehot;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .chip_sel(chip_sel),
        .clk(clk),
        .lane_sel(lane_sel),
        .onehot(onehot)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            chip_sel = 8'b0;
            lane_sel = 3'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            chip_sel = 8'h00;
            lane_sel = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            chip_sel = 8'h01;
            lane_sel = 3'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h0000000000000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            chip_sel = 8'h80;
            lane_sel = 3'd7;
            @(posedge clk);
            #1;


            #1;



            check_outputs(64'h8000000000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            chip_sel = 8'hFF;
            lane_sel = 3'd4;
            @(posedge clk);
            #1;


            #1;



            check_outputs(64'h1010101010101010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            chip_sel = 8'hAA;
            lane_sel = 3'd2;
            @(posedge clk);
            #1;


            #1;



            check_outputs(64'h0400040004000400);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            chip_sel = 8'h55;
            lane_sel = 3'd5;
            @(posedge clk);
            #1;


            #1;



            check_outputs(64'h0020002000200020);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            chip_sel = 8'h01;
            lane_sel = 3'd0;
            @(posedge clk);
            #1;

            lane_sel = 3'd3;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h0000000000000008);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            chip_sel = 8'h01;
            lane_sel = 3'd6;
            @(posedge clk);
            #1;

            chip_sel = 8'h02;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h0000000000004000);
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
        input [63:0] expected_onehot;
        begin
            if (expected_onehot === (expected_onehot ^ onehot ^ expected_onehot)) begin
                $display("PASS");
                $display("  Outputs: onehot=%h",
                         onehot);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: onehot=%h",
                         expected_onehot);
                $display("  Got:      onehot=%h",
                         onehot);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,chip_sel, clk, lane_sel, onehot);
    end

endmodule
