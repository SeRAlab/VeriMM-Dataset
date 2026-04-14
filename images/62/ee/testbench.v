`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] botIcon;
    reg clk;
    reg [11:0] firstscreen;
    reg video_on;
    reg [1:0] world;
    wire [11:0] drawIcon;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .botIcon(botIcon),
        .clk(clk),
        .firstscreen(firstscreen),
        .video_on(video_on),
        .world(world),
        .drawIcon(drawIcon)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            botIcon = 12'h000;
            video_on = 1'b0;
            world = 2'b00;
            firstscreen = 12'h000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Video Off Priority", test_num);
            video_on = 1'b0;
            botIcon = 12'hABC;
            world = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: botIcon Priority (Video ON)", test_num);
            video_on = 1'b1;
            botIcon = 12'h5A5;
            world = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h5A5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: World Mapping - White", test_num);
            video_on = 1'b1;
            botIcon = 12'h000;
            world = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: World Mapping - Black", test_num);
            video_on = 1'b1;
            botIcon = 12'h000;
            world = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: World Mapping - Red", test_num);
            video_on = 1'b1;
            botIcon = 12'h000;
            world = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hF00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: World Mapping - Green", test_num);
            video_on = 1'b1;
            botIcon = 12'h000;
            world = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h0F0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case %0d: Priority check - video_on vs botIcon", test_num);
            video_on = 1'b0;
            botIcon = 12'hFFF;
            world = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test Case %0d: Transition from world mapping to botIcon", test_num);
            video_on = 1'b1;
            botIcon = 12'h000;
            world = 2'b10;
            @(posedge clk);
            #1;

            botIcon = 12'h123;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h123);
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
        input [11:0] expected_drawIcon;
        begin
            if (expected_drawIcon === (expected_drawIcon ^ drawIcon ^ expected_drawIcon)) begin
                $display("PASS");
                $display("  Outputs: drawIcon=%h",
                         drawIcon);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: drawIcon=%h",
                         expected_drawIcon);
                $display("  Got:      drawIcon=%h",
                         drawIcon);
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
        $dumpvars(0,botIcon, clk, firstscreen, video_on, world, drawIcon);
    end

endmodule
