`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] CurrentX;
    reg [8:0] CurrentY;
    reg clk_vga;
    reg [7:0] wall;
    wire [7:0] mapData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CurrentX(CurrentX),
        .CurrentY(CurrentY),
        .clk_vga(clk_vga),
        .wall(wall),
        .mapData(mapData)
    );

    // Clock generation (10ns period)
    initial begin
        clk_vga = 0;
        forever #5 clk_vga = ~clk_vga;
    end

        task reset_dut;

        begin
            CurrentX <= 10'd0;
            CurrentY <= 9'd0;
            wall <= 8'd0;
            @(posedge clk_vga);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Origin Check", test_num);
            reset_dut();
            CurrentX <= 10'd0;
            CurrentY <= 9'd0;
            wall <= 8'h00;
            repeat(2) @(posedge clk_vga);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Center Screen Check", test_num);
            reset_dut();
            CurrentX <= 10'd320;
            CurrentY <= 9'd240;
            wall <= 8'h00;
            repeat(2) @(posedge clk_vga);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Boundary with Wall", test_num);
            reset_dut();
            CurrentX <= 10'd10;
            CurrentY <= 9'd10;
            wall <= 8'hFF;
            repeat(2) @(posedge clk_vga);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Right Boundary", test_num);
            reset_dut();
            CurrentX <= 10'd639;
            CurrentY <= 9'd240;
            wall <= 8'h0F;
            repeat(2) @(posedge clk_vga);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Bottom Boundary", test_num);
            reset_dut();
            CurrentX <= 10'd320;
            CurrentY <= 9'd479;
            wall <= 8'hAA;
            repeat(2) @(posedge clk_vga);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Out of Bounds", test_num);
            reset_dut();
            CurrentX <= 10'd800;
            CurrentY <= 9'd500;
            wall <= 8'h00;
            repeat(2) @(posedge clk_vga);
            #1;

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
        input [7:0] expected_mapData;
        begin
            if (expected_mapData === (expected_mapData ^ mapData ^ expected_mapData)) begin
                $display("PASS");
                $display("  Outputs: mapData=%h",
                         mapData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mapData=%h",
                         expected_mapData);
                $display("  Got:      mapData=%h",
                         mapData);
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
        $dumpvars(0,CurrentX, CurrentY, clk_vga, wall, mapData);
    end

endmodule
