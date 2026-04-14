`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg up_down;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            up_down = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset check", test_num);
            reset_dut();


            #1;



            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment 5 times", test_num);
            reset_dut();
            up_down = 1;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upward wrap around (17 cycles)", test_num);
            reset_dut();
            up_down = 1;
            for (i = 0; i < 17; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decrement wrap (0 to 15)", test_num);
            reset_dut();
            up_down = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decrement 4 times", test_num);
            reset_dut();
            up_down = 0;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Switch directions (Up 10, Down 3)", test_num);
            reset_dut();
            up_down = 1;
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            up_down = 0;
            for (i = 0; i < 3; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Downward wrap (20 cycles)", test_num);
            reset_dut();
            up_down = 0;
            for (i = 0; i < 20; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(4'hC);
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, reset, up_down, count);
    end

endmodule
