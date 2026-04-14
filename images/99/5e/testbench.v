`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Btn_L;
    reg Btn_R;
    reg clk;
    wire [2:0] RGB1;
    wire [2:0] RGB2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Btn_L(Btn_L),
        .Btn_R(Btn_R),
        .clk(clk),
        .RGB1(RGB1),
        .RGB2(RGB2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Btn_L = 0;
            Btn_R = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(3'b000, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Press Btn_L (RGB1 change)", test_num);
            reset_dut();
            Btn_L = 1;
            @(posedge clk);
            Btn_L = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b001, 3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Press Btn_R (RGB2 change)", test_num);
            reset_dut();
            Btn_R = 1;
            @(posedge clk);
            Btn_R = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b001, 3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Multiple Btn_L pulses", test_num);
            reset_dut();

            repeat(2) begin
                Btn_L = 1; @(posedge clk);
                Btn_L = 0; @(posedge clk);
            end
            #1;
            #1;

            check_outputs(3'b011, 3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Simultaneous Btn_L and Btn_R", test_num);
            reset_dut();
            Btn_L = 1;
            Btn_R = 1;
            @(posedge clk);
            Btn_L = 0;
            Btn_R = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b100, 3'b010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Holding button (checking for edge sensitivity)", test_num);
            reset_dut();
            Btn_L = 1;
            repeat(5) @(posedge clk);
            Btn_L = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(3'b101, 3'b010);
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
        input [2:0] expected_RGB1;
        input [2:0] expected_RGB2;
        begin
            if (expected_RGB1 === (expected_RGB1 ^ RGB1 ^ expected_RGB1) &&
                expected_RGB2 === (expected_RGB2 ^ RGB2 ^ expected_RGB2)) begin
                $display("PASS");
                $display("  Outputs: RGB1=%h, RGB2=%h",
                         RGB1, RGB2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RGB1=%h, RGB2=%h",
                         expected_RGB1, expected_RGB2);
                $display("  Got:      RGB1=%h, RGB2=%h",
                         RGB1, RGB2);
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
        $dumpvars(0,Btn_L, Btn_R, clk, RGB1, RGB2);
    end

endmodule
