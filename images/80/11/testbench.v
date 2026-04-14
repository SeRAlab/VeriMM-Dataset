`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] x_px;
    wire [2:0] color_px;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x_px(x_px),
        .color_px(color_px)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x_px = 0 (Start of White bar)", test_num);
        x_px = 10'd0;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x_px = 79 (End of White bar)", test_num);
        x_px = 10'd79;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x_px = 80 (Start of Yellow bar)", test_num);
        x_px = 10'd80;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x_px = 159 (End of Yellow bar)", test_num);
        x_px = 10'd159;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x_px = 160 (Start of Cyan bar)", test_num);
        x_px = 10'd160;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x_px = 240 (Start of Green bar)", test_num);
        x_px = 10'd240;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x_px = 320 (Start of Magenta bar)", test_num);
        x_px = 10'd320;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x_px = 400 (Start of Red bar)", test_num);
        x_px = 10'd400;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x_px = 480 (Start of Blue bar)", test_num);
        x_px = 10'd480;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x_px = 560 (Start of Black bar)", test_num);
        x_px = 10'd560;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x_px = 639 (End of display range)", test_num);
        x_px = 10'd639;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x_px = 640 (Outside range)", test_num);
        x_px = 10'd640;
        #1;

        check_outputs(3'b000);
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
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [2:0] expected_color_px;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_color_px === (expected_color_px ^ color_px ^ expected_color_px)) begin
                $display("PASS");
                $display("  Outputs: color_px=%h",
                         color_px);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: color_px=%h",
                         expected_color_px);
                $display("  Got:      color_px=%h",
                         color_px);
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

endmodule
