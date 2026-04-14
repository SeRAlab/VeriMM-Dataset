`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg edge_sel;
    reg [7:0] level;
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
        .edge_sel(edge_sel),
        .level(level),
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
            nrst = 1'b0;
            din = 8'd0;
            level = 8'd0;
            edge_sel = 1'b0;
            #15;
            nrst = 1'b1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            $display("Testcase %0d: Reset Check", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            level = 8'd50;
            edge_sel = 1'b1;
            din = 8'd40;
            @(posedge clk);
            #1;
            din = 8'd60;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Rising Edge Detection (40 -> 60, Level 50)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            level = 8'd50;
            edge_sel = 1'b0;
            din = 8'd60;
            @(posedge clk);
            #1;
            din = 8'd40;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Falling Edge Detection (60 -> 40, Level 50)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            level = 8'd50;
            edge_sel = 1'b1;
            din = 8'd10;
            @(posedge clk);
            #1;
            din = 8'd20;
            @(posedge clk);
            #1;
            $display("Testcase %0d: No Trigger (Below Level)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            level = 8'd50;
            edge_sel = 1'b1;
            din = 8'd60;
            @(posedge clk);
            #1;
            din = 8'd40;
            @(posedge clk);
            #1;
            $display("Testcase %0d: No Trigger (Wrong Edge Type)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            level = 8'd100;
            edge_sel = 1'b1;
            din = 8'd90;
            @(posedge clk);
            #1;
            din = 8'd100;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Boundary Trigger (90 -> 100, Level 100)", test_num);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            level = 8'd50;
            edge_sel = 1'b1;
            din = 8'd60;
            @(posedge clk);
            #1;
            din = 8'd65;
            @(posedge clk);
            #1;
            din = 8'd70;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Steady Input Above Level (No new edge)", test_num);



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            level = 8'd50;
            edge_sel = 1'b1;
            din = 8'd40;
            @(posedge clk);
            #1;
            din = 8'd60;
            @(posedge clk);
            #1;

            nrst = 1'b0;
            #2;
            $display("Testcase %0d: Async Reset Mid-Operation", test_num);
            #1;

            check_outputs(1'b0);
            nrst = 1'b1;
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
        $dumpvars(0,clk, din, edge_sel, level, nrst, trig_out);
    end

endmodule
