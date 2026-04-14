`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg B_input;
    reg G_input;
    reg Pixel_clock;
    reg R_input;
    reg change_color;
    wire blue_reg;
    wire green_reg;
    wire red_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B_input(B_input),
        .G_input(G_input),
        .Pixel_clock(Pixel_clock),
        .R_input(R_input),
        .change_color(change_color),
        .blue_reg(blue_reg),
        .green_reg(green_reg),
        .red_reg(red_reg)
    );

    // Clock generation (10ns period)
    initial begin
        Pixel_clock = 0;
        forever #5 Pixel_clock = ~Pixel_clock;
    end

        task reset_dut;

        begin
            @(negedge Pixel_clock);
            change_color = 1'b1;
            R_input = 1'b0;
            G_input = 1'b0;
            B_input = 1'b0;
            @(posedge Pixel_clock);
            #1;
            change_color = 1'b0;
            $display("DUT Reset: Registers cleared to 0");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Update registers to all-high", test_num);
            reset_dut();

            @(negedge Pixel_clock);
            R_input = 1'b1;
            G_input = 1'b1;
            B_input = 1'b1;
            change_color = 1'b1;

            @(posedge Pixel_clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Verify retention when change_color is LOW", test_num);
            reset_dut();

            @(negedge Pixel_clock);
            R_input = 1'b1;
            G_input = 1'b1;
            B_input = 1'b1;
            change_color = 1'b0;

            @(posedge Pixel_clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Update Red component only", test_num);
            reset_dut();

            @(negedge Pixel_clock);
            R_input = 1'b1;
            G_input = 1'b0;
            B_input = 1'b0;
            change_color = 1'b1;

            @(posedge Pixel_clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Data retention across multiple cycles", test_num);
            reset_dut();


            @(negedge Pixel_clock);
            R_input = 1'b0; G_input = 1'b1; B_input = 1'b0; change_color = 1'b1;
            @(posedge Pixel_clock);


            @(negedge Pixel_clock);
            change_color = 1'b0;
            R_input = 1'b1; G_input = 1'b0; B_input = 1'b1;


            repeat(2) @(posedge Pixel_clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Pulse change_color for a single cycle update", test_num);
            reset_dut();

            @(negedge Pixel_clock);
            R_input = 1'b1; G_input = 1'b0; B_input = 1'b1;
            change_color = 1'b1;
            @(posedge Pixel_clock);

            @(negedge Pixel_clock);
            change_color = 1'b0;
            R_input = 1'b0; G_input = 1'b1; B_input = 1'b0;
            @(posedge Pixel_clock);

            #2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
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
        input expected_blue_reg;
        input expected_green_reg;
        input expected_red_reg;
        begin
            if (expected_blue_reg === (expected_blue_reg ^ blue_reg ^ expected_blue_reg) &&
                expected_green_reg === (expected_green_reg ^ green_reg ^ expected_green_reg) &&
                expected_red_reg === (expected_red_reg ^ red_reg ^ expected_red_reg)) begin
                $display("PASS");
                $display("  Outputs: blue_reg=%b, green_reg=%b, red_reg=%b",
                         blue_reg, green_reg, red_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blue_reg=%b, green_reg=%b, red_reg=%b",
                         expected_blue_reg, expected_green_reg, expected_red_reg);
                $display("  Got:      blue_reg=%b, green_reg=%b, red_reg=%b",
                         blue_reg, green_reg, red_reg);
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
        $dumpvars(0,B_input, G_input, Pixel_clock, R_input, change_color, blue_reg, green_reg, red_reg);
    end

endmodule
