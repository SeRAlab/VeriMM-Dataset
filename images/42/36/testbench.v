`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg [2:0] sel;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .sel(sel),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 0;
            sel = 0;
            data0 = 0; data1 = 0; data2 = 0;
            data3 = 0; data4 = 0; data5 = 0;

            force dut.q = 4'b0000;
            @(posedge clk);
            #1;
            release dut.q;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            data0 = 4'b1010;
            sel = 3'd0;
            d = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            data1 = 4'b0101;
            sel = 3'd1;
            d = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            data2 = 4'b1111;
            sel = 3'd2;
            d = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            data3 = 4'b0011;
            sel = 3'd3;
            d = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            data4 = 4'b1100;
            sel = 3'd4;
            d = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            data5 = 4'b1001;
            sel = 3'd5;
            d = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            data0 = 4'b1111;
            sel = 3'd0;
            d = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            data0 = 4'b1011;
            sel = 3'd0;
            d = 1'b1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, data0, data1, data2, data3, data4, data5, sel, q);
    end

endmodule
