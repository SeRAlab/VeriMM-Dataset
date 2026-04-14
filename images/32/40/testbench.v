`timescale 1ns/1ps

module SLAM_Update_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] curr_position;
    reg [7:0] map_update;
    reg rst;
    wire [7:0] updated_map;
    wire [7:0] updated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM_Update dut (
        .clk(clk),
        .curr_position(curr_position),
        .map_update(map_update),
        .rst(rst),
        .updated_map(updated_map),
        .updated_position(updated_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            curr_position = 0;
            map_update = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: Zero Inputs", test_num);
            reset_dut();
            curr_position = 8'h00;
            map_update = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: Simple Update", test_num);
            reset_dut();
            curr_position = 8'd50;
            map_update = 8'd20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd20, 8'd70);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %0d: Large Values", test_num);
            reset_dut();
            curr_position = 8'd128;
            map_update = 8'd100;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd100, 8'd228);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %0d: Overflow Case", test_num);
            reset_dut();
            curr_position = 8'd200;
            map_update = 8'd100;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd100, 8'd44);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %0d: Zero Map Update", test_num);
            reset_dut();
            curr_position = 8'hFF;
            map_update = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %0d: Zero Start Position", test_num);
            reset_dut();
            curr_position = 8'h00;
            map_update = 8'hA5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SLAM_Update Testbench");
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
        input [7:0] expected_updated_map;
        input [7:0] expected_updated_position;
        begin
            if (expected_updated_map === (expected_updated_map ^ updated_map ^ expected_updated_map) &&
                expected_updated_position === (expected_updated_position ^ updated_position ^ expected_updated_position)) begin
                $display("PASS");
                $display("  Outputs: updated_map=%h, updated_position=%h",
                         updated_map, updated_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_map=%h, updated_position=%h",
                         expected_updated_map, expected_updated_position);
                $display("  Got:      updated_map=%h, updated_position=%h",
                         updated_map, updated_position);
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
        $dumpvars(0,clk, curr_position, map_update, rst, updated_map, updated_position);
    end

endmodule
