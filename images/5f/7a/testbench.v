`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg load;
    reg shift;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .load(load),
        .shift(shift),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load <= 1'b1;
            data <= 16'h0000;
            shift <= 1'b0;
            @(posedge clk);
            load <= 1'b0;
            data <= 16'h0000;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Load 0xABCD", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1'b1;
            data <= 16'hABCD;
            @(posedge clk);
            load <= 1'b0;
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0x8001 and Shift Right once", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1'b1;
            data <= 16'h8001;
            @(posedge clk);
            load <= 1'b0;
            shift <= 1'b1;
            @(posedge clk);
            shift <= 1'b0;
            #1;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0xF000 and Shift Right 4 times", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1'b1;
            data <= 16'hF000;
            @(posedge clk);
            load <= 1'b0;
            shift <= 1'b1;
            repeat(4) @(posedge clk);
            shift <= 1'b0;
            #1;
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority test - Load and Shift both high", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1'b1;
            data <= 16'h5555;
            shift <= 1'b1;
            @(posedge clk);
            load <= 1'b0;
            shift <= 1'b0;
            #1;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold value test", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1'b1;
            data <= 16'hA5A5;
            @(posedge clk);
            load <= 1'b0;
            shift <= 1'b0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right 16 times", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1'b1;
            data <= 16'hFFFF;
            @(posedge clk);
            load <= 1'b0;
            shift <= 1'b1;
            repeat(16) @(posedge clk);
            shift <= 1'b0;
            #1;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, load, shift, q);
    end

endmodule
