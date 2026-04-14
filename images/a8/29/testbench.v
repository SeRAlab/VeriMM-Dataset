`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg rst;
    wire [3:0] anode;
    wire [7:0] cathode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .rst(rst),
        .anode(anode),
        .cathode(cathode)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in0 = 8'h00;
            in1 = 8'h00;
            in2 = 8'h00;
            in3 = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in0 = 8'hA0; in1 = 8'hB1; in2 = 8'hC2; in3 = 8'hD3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1110, 8'hA0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in0 = 8'hA0; in1 = 8'hB1; in2 = 8'hC2; in3 = 8'hD3;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1101, 8'hB1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            in0 = 8'hA0; in1 = 8'hB1; in2 = 8'hC2; in3 = 8'hD3;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1011, 8'hC2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in0 = 8'hA0; in1 = 8'hB1; in2 = 8'hC2; in3 = 8'hD3;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0111, 8'hD3);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            rst = 1;
            in0 = 8'hFF;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1111, 8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            in0 = 8'h11; in1 = 8'h22; in2 = 8'h33; in3 = 8'h44;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1110, 8'h11);
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
        input [3:0] expected_anode;
        input [7:0] expected_cathode;
        begin
            if (expected_anode === (expected_anode ^ anode ^ expected_anode) &&
                expected_cathode === (expected_cathode ^ cathode ^ expected_cathode)) begin
                $display("PASS");
                $display("  Outputs: anode=%h, cathode=%h",
                         anode, cathode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: anode=%h, cathode=%h",
                         expected_anode, expected_cathode);
                $display("  Got:      anode=%h, cathode=%h",
                         anode, cathode);
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
        $dumpvars(0,clk, in0, in1, in2, in3, rst, anode, cathode);
    end

endmodule
