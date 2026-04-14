`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] ObjectH;
    reg [9:0] ObjectW;
    reg [10:0] ObjectX;
    reg [9:0] ObjectY;
    reg [9:0] PollX;
    reg [8:0] PollY;
    reg clk;
    reg reset;
    wire Hit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ObjectH(ObjectH),
        .ObjectW(ObjectW),
        .ObjectX(ObjectX),
        .ObjectY(ObjectY),
        .PollX(PollX),
        .PollY(PollY),
        .clk(clk),
        .reset(reset),
        .Hit(Hit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ObjectX = 0; ObjectY = 0; ObjectW = 0; ObjectH = 0;
            PollX = 0; PollY = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            ObjectX = 100; ObjectY = 100; ObjectW = 50; ObjectH = 50;
            PollX = 125; PollY = 125;
            reset = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking reset priority...", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            ObjectX = 100; ObjectY = 100; ObjectW = 50; ObjectH = 50;
            PollX = 125; PollY = 125;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Point clearly inside object...", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            ObjectX = 100; ObjectY = 100; ObjectW = 50; ObjectH = 50;
            PollX = 50; PollY = 125;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Point to the left of object...", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            ObjectX = 100; ObjectY = 100; ObjectW = 50; ObjectH = 50;
            PollX = 200; PollY = 125;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Point to the right of object...", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            ObjectX = 100; ObjectY = 100; ObjectW = 50; ObjectH = 50;
            PollX = 125; PollY = 50;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Point above object...", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            ObjectX = 100; ObjectY = 100; ObjectW = 50; ObjectH = 50;
            PollX = 125; PollY = 200;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Point below object...", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            ObjectX = 100; ObjectY = 100; ObjectW = 50; ObjectH = 50;
            PollX = 100; PollY = 100;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Point exactly on Top-Left boundary...", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            ObjectX = 100; ObjectY = 100; ObjectW = 50; ObjectH = 50;


            PollX = 149; PollY = 149;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Point inside Bottom-Right edge...", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            ObjectX = 100; ObjectY = 100; ObjectW = 50; ObjectH = 50;
            PollX = 150; PollY = 150;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Point just outside Bottom-Right edge...", test_num);
            #1;

            check_outputs(0);
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
        input expected_Hit;
        begin
            if (expected_Hit === (expected_Hit ^ Hit ^ expected_Hit)) begin
                $display("PASS");
                $display("  Outputs: Hit=%b",
                         Hit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Hit=%b",
                         expected_Hit);
                $display("  Got:      Hit=%b",
                         Hit);
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
        $dumpvars(0,ObjectH, ObjectW, ObjectX, ObjectY, PollX, PollY, clk, reset, Hit);
    end

endmodule
