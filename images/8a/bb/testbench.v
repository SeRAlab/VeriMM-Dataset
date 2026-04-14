`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg edge_mask;
    reg [2:0] edge_sel;
    reg [7:0] level_mask;
    reg [7:0] level_sel;
    reg nrst;
    wire trig_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .edge_mask(edge_mask),
        .edge_sel(edge_sel),
        .level_mask(level_mask),
        .level_sel(level_sel),
        .nrst(nrst),
        .trig_out(trig_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            nrst = 0;
            din = 0;
            edge_mask = 0;
            edge_sel = 0;
            level_mask = 0;
            level_sel = 0;
            repeat(2) @(posedge clk);
            #1 nrst = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            level_mask = 8'hFF;
            level_sel = 8'hA5;
            din = 8'hA5;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            level_mask = 8'hFF;
            level_sel = 8'hA5;
            din = 8'h5A;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            level_mask = 8'h0F;
            level_sel = 8'h0A;
            din = 8'hFA;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            edge_mask = 1'b1;
            edge_sel = 3'd2;
            din = 8'h00;
            @(posedge clk);
            din = 8'h04;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            edge_mask = 1'b1;
            edge_sel = 3'd7;
            din = 8'h80;
            @(posedge clk);
            din = 8'h00;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            edge_mask = 1'b0;
            edge_sel = 3'd4;
            din = 8'h00;
            @(posedge clk);
            din = 8'h10;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            edge_mask = 1'b1;
            edge_sel = 3'd0;
            din = 8'h00;
            @(posedge clk);
            din = 8'h02;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            level_mask = 8'h80;
            level_sel = 8'h80;
            edge_mask = 1'b1;
            edge_sel = 3'd0;
            din = 8'h00;
            @(posedge clk);
            din = 8'h01;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            edge_mask = 1'b1;
            edge_sel = 3'd1;
            din = 8'h00;
            @(posedge clk);
            din = 8'h02;
            @(posedge clk);


            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
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
        input expected_trig_out;
        begin
            if (expected_trig_out === (expected_trig_out ^ trig_out ^ expected_trig_out)) begin
                $display("PASS");
                $display("  Outputs: trig_out=%b",
                         trig_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: trig_out=%b",
                         expected_trig_out);
                $display("  Got:      trig_out=%b",
                         trig_out);
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
        $dumpvars(0,clk, din, edge_mask, edge_sel, level_mask, level_sel, nrst, trig_out);
    end

endmodule
