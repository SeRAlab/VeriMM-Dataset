`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] amount;
    reg clk;
    reg data;
    reg load;
    reg reset;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .amount(amount),
        .clk(clk),
        .data(data),
        .load(load),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            amount = 0;
            data = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data = 32'hACE1BEEF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            $display("Testcase %0d: Parallel Load", test_num);
            #1;

            check_outputs(32'hACE1BEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            data = 32'h0000000F;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            amount = 2'b00;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Shift Left 2 bits", test_num);
            #1;

            check_outputs(32'h0000003C);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 32'h0000000F;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            amount = 2'b01;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Shift Left 4 bits", test_num);
            #1;

            check_outputs(32'h000000F0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 32'hF0000000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            amount = 2'b10;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Shift Right 2 bits", test_num);
            #1;

            check_outputs(32'h3C000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 32'hF0000000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            amount = 2'b11;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Shift Right 4 bits", test_num);
            #1;

            check_outputs(32'h0F000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            reset_dut();
            data = 32'hFFFFFFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            $display("Testcase %0d: Reset Clearance", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data = 32'h00000001;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            amount = 2'b00;
            @(posedge clk);
            #1 amount = 2'b01;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Successive Left Shifts (2 then 4)", test_num);
            #1;

            check_outputs(32'h00000040);
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
        input [31:0] expected_q;
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
        $dumpvars(0,amount, clk, data, load, reset, q);
    end

endmodule
