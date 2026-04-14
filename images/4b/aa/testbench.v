`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg reset;
    wire [15:0] edge_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .edge_detected(edge_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 0;
            @(posedge clk);
            #1;
            reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Bit Rising Edge", test_num);
            reset_dut();
            data = 16'h0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: All Bits Rising Edge", test_num);
            reset_dut();
            data = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Sustained High (No new edges)", test_num);
            reset_dut();
            data = 16'hFFFF;
            @(posedge clk);
            #1;
            data = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Falling Edge (Should not trigger)", test_num);
            reset_dut();
            data = 16'hFFFF;
            @(posedge clk);
            #1;
            data = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Complex Bit Pattern Transition", test_num);
            reset_dut();
            data = 16'h5555;
            @(posedge clk);
            #1;
            data = 16'hAAAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Overlapping Bits Transition", test_num);
            reset_dut();
            data = 16'h0F0F;
            @(posedge clk);
            #1;
            data = 16'hFF00;
            @(posedge clk);
            #1;



            #1;




            check_outputs(16'hF000);
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
        input [15:0] expected_edge_detected;
        begin
            if (expected_edge_detected === (expected_edge_detected ^ edge_detected ^ expected_edge_detected)) begin
                $display("PASS");
                $display("  Outputs: edge_detected=%h",
                         edge_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_detected=%h",
                         expected_edge_detected);
                $display("  Got:      edge_detected=%h",
                         edge_detected);
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
        $dumpvars(0,clk, data, reset, edge_detected);
    end

endmodule
