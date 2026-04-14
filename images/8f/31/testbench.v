`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] datain;
    reg [3:0] neural_addr;
    reg rd;
    reg [3:0] weight_addr;
    reg wt;
    wire [9:0] dataout0;
    wire [9:0] dataout1;
    wire [9:0] dataout2;
    wire [9:0] dataout3;
    wire [9:0] dataout4;
    wire [9:0] dataout5;
    wire [9:0] dataout6;
    wire [9:0] dataout7;
    wire [9:0] dataout8;
    wire [9:0] dataout9;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .neural_addr(neural_addr),
        .rd(rd),
        .weight_addr(weight_addr),
        .wt(wt),
        .dataout0(dataout0),
        .dataout1(dataout1),
        .dataout2(dataout2),
        .dataout3(dataout3),
        .dataout4(dataout4),
        .dataout5(dataout5),
        .dataout6(dataout6),
        .dataout7(dataout7),
        .dataout8(dataout8),
        .dataout9(dataout9)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk = 0;
            datain = 0;
            neural_addr = 0;
            weight_addr = 0;
            rd = 0;
            wt = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read to Neuron 0");
            reset_dut();


            @(posedge clk);
            wt = 1; rd = 0;
            neural_addr = 4'd0;
            weight_addr = 4'd0;
            datain = 10'h1A5;

            @(posedge clk);
            wt = 0;


            @(posedge clk);
            rd = 1; wt = 0;
            neural_addr = 4'd0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h1A5, 0, 0, 0, 0, 0, 0, 0, 0, 0);
            rd = 0;
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("Running testcase002: Writing full row to Neuron 5");
            reset_dut();


            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                wt = 1; rd = 0;
                neural_addr = 4'd5;
                weight_addr = i;
                datain = 10'd100 + i;
            end

            @(posedge clk);
            wt = 0;


            @(posedge clk);
            rd = 1;
            neural_addr = 4'd5;

            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd100, 10'd101, 10'd102, 10'd103, 10'd104, 10'd105, 10'd106, 10'd107, 10'd108, 10'd109);
            rd = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Cross-neuron isolation check");
            reset_dut();


            @(posedge clk);
            wt = 1; neural_addr = 4'd2; weight_addr = 4'd3; datain = 10'h3FF;
            @(posedge clk);

            wt = 1; neural_addr = 4'd3; weight_addr = 4'd3; datain = 10'h0AA;

            @(posedge clk);
            wt = 0;


            @(posedge clk);
            rd = 1; neural_addr = 4'd2;
            @(posedge clk);
            #1;

            if (dataout3 == 10'h3FF) begin

                @(posedge clk);
                neural_addr = 4'd3;
                @(posedge clk);
                #1;

                #1;


                check_outputs(0, 0, 0, 10'h0AA, 0, 0, 0, 0, 0, 0);
            end else begin
                #1;

                check_outputs(0, 0, 0, 10'h3FF, 0, 0, 0, 0, 0, 0);
            end
            rd = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write enable logic check");
            reset_dut();


            @(posedge clk);
            wt = 0; rd = 0;
            neural_addr = 4'd1;
            weight_addr = 4'd1;
            datain = 10'h222;

            @(posedge clk);

            rd = 1;
            neural_addr = 4'd1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
            rd = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwriting existing values");
            reset_dut();


            @(posedge clk);
            wt = 1; neural_addr = 4'd9; weight_addr = 4'd9; datain = 10'h111;
            @(posedge clk);

            wt = 1; neural_addr = 4'd9; weight_addr = 4'd9; datain = 10'h333;

            @(posedge clk);
            wt = 0; rd = 1; neural_addr = 4'd9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 10'h333);
            rd = 0;
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
        input [9:0] expected_dataout0;
        input [9:0] expected_dataout1;
        input [9:0] expected_dataout2;
        input [9:0] expected_dataout3;
        input [9:0] expected_dataout4;
        input [9:0] expected_dataout5;
        input [9:0] expected_dataout6;
        input [9:0] expected_dataout7;
        input [9:0] expected_dataout8;
        input [9:0] expected_dataout9;
        begin
            if (expected_dataout0 === (expected_dataout0 ^ dataout0 ^ expected_dataout0) &&
                expected_dataout1 === (expected_dataout1 ^ dataout1 ^ expected_dataout1) &&
                expected_dataout2 === (expected_dataout2 ^ dataout2 ^ expected_dataout2) &&
                expected_dataout3 === (expected_dataout3 ^ dataout3 ^ expected_dataout3) &&
                expected_dataout4 === (expected_dataout4 ^ dataout4 ^ expected_dataout4) &&
                expected_dataout5 === (expected_dataout5 ^ dataout5 ^ expected_dataout5) &&
                expected_dataout6 === (expected_dataout6 ^ dataout6 ^ expected_dataout6) &&
                expected_dataout7 === (expected_dataout7 ^ dataout7 ^ expected_dataout7) &&
                expected_dataout8 === (expected_dataout8 ^ dataout8 ^ expected_dataout8) &&
                expected_dataout9 === (expected_dataout9 ^ dataout9 ^ expected_dataout9)) begin
                $display("PASS");
                $display("  Outputs: dataout0=%h, dataout1=%h, dataout2=%h, dataout3=%h, dataout4=%h, dataout5=%h, dataout6=%h, dataout7=%h, dataout8=%h, dataout9=%h",
                         dataout0, dataout1, dataout2, dataout3, dataout4, dataout5, dataout6, dataout7, dataout8, dataout9);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout0=%h, dataout1=%h, dataout2=%h, dataout3=%h, dataout4=%h, dataout5=%h, dataout6=%h, dataout7=%h, dataout8=%h, dataout9=%h",
                         expected_dataout0, expected_dataout1, expected_dataout2, expected_dataout3, expected_dataout4, expected_dataout5, expected_dataout6, expected_dataout7, expected_dataout8, expected_dataout9);
                $display("  Got:      dataout0=%h, dataout1=%h, dataout2=%h, dataout3=%h, dataout4=%h, dataout5=%h, dataout6=%h, dataout7=%h, dataout8=%h, dataout9=%h",
                         dataout0, dataout1, dataout2, dataout3, dataout4, dataout5, dataout6, dataout7, dataout8, dataout9);
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
        $dumpvars(0,clk, datain, neural_addr, rd, weight_addr, wt, dataout0, dataout1, dataout2, dataout3, dataout4, dataout5, dataout6, dataout7, dataout8, dataout9);
    end

endmodule
