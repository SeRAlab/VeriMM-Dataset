`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    wire [9:0] HC;
    wire HSYNC;
    wire [9:0] VC;
    wire VIDON;
    wire VSYNC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLR(CLR),
        .HC(HC),
        .HSYNC(HSYNC),
        .VC(VC),
        .VIDON(VIDON),
        .VSYNC(VSYNC)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLR = 1;
            @(posedge CLK);
            #2;
            CLR = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(10'd0, 1'b1, 10'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            reset_dut();

            for (i = 0; i < 639; i = i + 1) @(posedge CLK);
            #2;

            #1;


            check_outputs(10'd639, 1'b1, 10'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();

            for (i = 0; i < 640; i = i + 1) @(posedge CLK);
            #2;

            #1;


            check_outputs(10'd640, 1'b1, 10'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();

            for (i = 0; i < 656; i = i + 1) @(posedge CLK);
            #2;

            #1;


            check_outputs(10'd656, 1'b0, 10'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();

            for (i = 0; i < 800; i = i + 1) @(posedge CLK);
            #2;

            #1;


            check_outputs(10'd0, 1'b1, 10'd1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            reset_dut();


            repeat (392000) @(posedge CLK);
            #2;

            #1;


            check_outputs(10'd0, 1'b1, 10'd490, 1'b0, 1'b0);
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
        input [9:0] expected_HC;
        input expected_HSYNC;
        input [9:0] expected_VC;
        input expected_VIDON;
        input expected_VSYNC;
        begin
            if (expected_HC === (expected_HC ^ HC ^ expected_HC) &&
                expected_HSYNC === (expected_HSYNC ^ HSYNC ^ expected_HSYNC) &&
                expected_VC === (expected_VC ^ VC ^ expected_VC) &&
                expected_VIDON === (expected_VIDON ^ VIDON ^ expected_VIDON) &&
                expected_VSYNC === (expected_VSYNC ^ VSYNC ^ expected_VSYNC)) begin
                $display("PASS");
                $display("  Outputs: HC=%h, HSYNC=%b, VC=%h, VIDON=%b, VSYNC=%b",
                         HC, HSYNC, VC, VIDON, VSYNC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HC=%h, HSYNC=%b, VC=%h, VIDON=%b, VSYNC=%b",
                         expected_HC, expected_HSYNC, expected_VC, expected_VIDON, expected_VSYNC);
                $display("  Got:      HC=%h, HSYNC=%b, VC=%h, VIDON=%b, VSYNC=%b",
                         HC, HSYNC, VC, VIDON, VSYNC);
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
        $dumpvars(0,CLK, CLR, HC, HSYNC, VC, VIDON, VSYNC);
    end

endmodule
