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
            CurrentX = 0;
            CurrentY = 0;
            wall = 8'h00;
            @(posedge clk_vga);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Top-Left Corner (0,0)", test_num);
            CurrentX = 10'd0;
            CurrentY = 9'd0;
            wall = 8'hFF;
            @(posedge clk_vga);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Center of Screen (320, 240)", test_num);
            CurrentX = 10'd320;
            CurrentY = 9'd240;
            wall = 8'hFF;
            @(posedge clk_vga);
            #2;
            #1;

            check_outputs(DEFAULT_COLOR);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Left Boundary Point (5, 100)", test_num);
            CurrentX = 10'd5;
            CurrentY = 9'd100;
            wall = 8'hAA;
            @(posedge clk_vga);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Right Boundary Point (635, 100)", test_num);
            CurrentX = 10'd635;
            CurrentY = 9'd100;
            wall = 8'hCC;
            @(posedge clk_vga);
            #2;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Top Boundary Point (300, 5)", test_num);
            CurrentX = 10'd300;
            CurrentY = 9'd5;
            wall = 8'h11;
            @(posedge clk_vga);
            #2;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Bottom Boundary Point (300, 475)", test_num);
            CurrentX = 10'd300;
            CurrentY = 9'd475;
            wall = 8'h22;
            @(posedge clk_vga);
            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Near Boundary (Background Side) (20, 20)", test_num);
            CurrentX = 10'd20;
            CurrentY = 9'd20;
            wall = 8'hFF;
            @(posedge clk_vga);
            #2;
            #1;

            check_outputs(DEFAULT_COLOR);
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
