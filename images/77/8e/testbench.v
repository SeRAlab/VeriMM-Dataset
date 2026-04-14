`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] button;
    reg clk;
    reg [9:0] xpos;
    reg [9:0] ypos;
    wire [4:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button(button),
        .clk(clk),
        .xpos(xpos),
        .ypos(ypos),
        .LED(LED)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            button = 2'b00;
            xpos = 10'd512;
            ypos = 10'd512;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Idle State (Center, No Buttons)", test_num);
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            button = 2'b01;
            @(posedge clk);
            #1;
            $display("Test %0d: Button 0 Pressed", test_num);
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            button = 2'b10;
            @(posedge clk);
            #1;
            $display("Test %0d: Button 1 Pressed", test_num);
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            button = 2'b11;
            @(posedge clk);
            #1;
            $display("Test %0d: Both Buttons Pressed", test_num);
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            xpos = 10'd100;
            @(posedge clk);
            #1;
            $display("Test %0d: Joystick Left", test_num);
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            xpos = 10'd800;
            @(posedge clk);
            #1;
            $display("Test %0d: Joystick Right", test_num);
            #1;

            check_outputs(5'b00100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            ypos = 10'd900;
            @(posedge clk);
            #1;
            $display("Test %0d: Joystick Above", test_num);
            #1;

            check_outputs(5'b01000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            ypos = 10'd200;
            @(posedge clk);
            #1;
            $display("Test %0d: Joystick Below", test_num);
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            button = 2'b01;
            xpos = 10'd50;
            ypos = 10'd700;
            @(posedge clk);
            #1;
            $display("Test %0d: Composite (Btn0 + Left + Above)", test_num);

            #1;


            check_outputs(5'b01011);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            xpos = 10'd384;
            ypos = 10'd640;
            @(posedge clk);
            #1;
            $display("Test %0d: Boundary Value Check", test_num);
            #1;

            check_outputs(5'b00000);
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
        input [4:0] expected_LED;
        begin
            if (expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: LED=%h",
                         LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h",
                         expected_LED);
                $display("  Got:      LED=%h",
                         LED);
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
        $dumpvars(0,button, clk, xpos, ypos, LED);
    end

endmodule
