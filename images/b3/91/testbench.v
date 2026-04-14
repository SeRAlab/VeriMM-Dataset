`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg load;
    reg [7:0] reset_variable;
    reg rst;
    reg up_down;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .load(load),
        .reset_variable(reset_variable),
        .rst(rst),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            init_inputs();
            @(negedge clk);
            rst = 1'b1;
            @(negedge clk);
            rst = 1'b0;
        end
        endtask
    task init_inputs;

        begin
            data = 8'h00;
            load = 1'b0;
            reset_variable = 8'hFF;
            rst = 1'b0;
            up_down = 1'b1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            data = 8'hA5;
            load = 1'b1;
            @(negedge clk);
            load = 1'b0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            up_down = 1'b1;
            repeat(10) @(negedge clk);
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(negedge clk);
            data = 8'd100;
            load = 1'b1;
            @(negedge clk);
            load = 1'b0;
            up_down = 1'b0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(8'd95);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            reset_variable = 8'd5;
            up_down = 1'b1;






            repeat(6) @(negedge clk);
            #1;

            check_outputs(8'd00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(negedge clk);
            data = 8'd200;
            load = 1'b1;
            @(negedge clk);
            load = 1'b0;
            reset_variable = 8'd198;
            up_down = 1'b0;



            repeat(3) @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(negedge clk);
            data = 8'hFF;
            load = 1'b1;
            @(negedge clk);
            load = 1'b0;
            up_down = 1'b1;
            @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            @(negedge clk);
            data = 8'h55;
            load = 1'b1;
            up_down = 1'b1;
            @(negedge clk);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            @(negedge clk);
            data = 8'hFF;
            load = 1'b1;
            rst = 1'b1;
            @(negedge clk);
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, data, load, reset_variable, rst, up_down, count);
    end

endmodule
