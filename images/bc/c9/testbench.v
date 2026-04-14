`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg [3:0] dst;
    reg rst;
    reg [3:0] src0;
    reg [3:0] src1;
    reg we;
    wire [7:0] data0;
    wire [7:0] data1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .dst(dst),
        .rst(rst),
        .src0(src0),
        .src1(src1),
        .we(we),
        .data0(data0),
        .data1(data1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            we = 0;
            dst = 0;
            src0 = 0;
            src1 = 0;
            data = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Synchronous Reset Check", test_num);
            reset_dut();

            src0 = 4'h5;
            src1 = 4'hF;
            #2;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Write/Read", test_num);
            reset_dut();

            we = 1;
            dst = 4'h3;
            data = 8'hA5;
            @(posedge clk);
            #1;
            we = 0;
            src0 = 4'h3;
            src1 = 4'h0;
            #2;
            #1;

            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Dual Port Read", test_num);
            reset_dut();

            we = 1; dst = 4'h7; data = 8'h77;
            @(posedge clk);

            we = 1; dst = 4'h8; data = 8'h88;
            @(posedge clk);
            #1;
            we = 0;
            src0 = 4'h7;
            src1 = 4'h8;
            #2;
            #1;

            check_outputs(8'h77, 8'h88);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Write Enable Inhibition", test_num);
            reset_dut();

            we = 0;
            dst = 4'h2;
            data = 8'hFF;
            @(posedge clk);
            #1;
            src0 = 4'h2;
            src1 = 4'h0;
            #2;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Register Overwrite", test_num);
            reset_dut();

            we = 1; dst = 4'hA; data = 8'h11;
            @(posedge clk);

            we = 1; dst = 4'hA; data = 8'h22;
            @(posedge clk);
            #1;
            we = 0;
            src0 = 4'hA;
            src1 = 4'hA;
            #2;
            #1;

            check_outputs(8'h22, 8'h22);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Boundary Address Check", test_num);
            reset_dut();

            we = 1; dst = 4'h0; data = 8'h01;
            @(posedge clk);

            we = 1; dst = 4'hF; data = 8'hFE;
            @(posedge clk);
            #1;
            we = 0;
            src0 = 4'h0;
            src1 = 4'hF;
            #2;
            #1;

            check_outputs(8'h01, 8'hFE);
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
        input [7:0] expected_data0;
        input [7:0] expected_data1;
        begin
            if (expected_data0 === (expected_data0 ^ data0 ^ expected_data0) &&
                expected_data1 === (expected_data1 ^ data1 ^ expected_data1)) begin
                $display("PASS");
                $display("  Outputs: data0=%h, data1=%h",
                         data0, data1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data0=%h, data1=%h",
                         expected_data0, expected_data1);
                $display("  Got:      data0=%h, data1=%h",
                         data0, data1);
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
        $dumpvars(0,clk, data, dst, rst, src0, src1, we, data0, data1);
    end

endmodule
