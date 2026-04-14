`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg [7:0] e;
    wire out_case;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .e(e),
        .out_case(out_case)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        d <= 8'h00;
        e <= 8'h00;

        @(posedge clk);
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        d <= 8'h00;
        e <= 8'h00;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: Inputs d=00, e=00", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        d <= 8'h01;
        e <= 8'h00;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: Inputs d=01, e=00", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        d <= 8'hFF;
        e <= 8'hFF;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: Inputs d=FF, e=FF", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        d <= 8'hFF;
        e <= 8'h00;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: Inputs d=FF, e=00", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        d <= 8'h7F;
        e <= 8'h00;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: Inputs d=7F, e=00", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        d <= 8'hAA;
        e <= 8'h55;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: Inputs d=AA, e=55", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        d <= 8'h03;
        e <= 8'h00;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: Inputs d=03, e=00", test_num);
        #1;

        check_outputs(1'b0);
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
        input expected_out_case;
        begin
            if (expected_out_case === (expected_out_case ^ out_case ^ expected_out_case)) begin
                $display("PASS");
                $display("  Outputs: out_case=%b",
                         out_case);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_case=%b",
                         expected_out_case);
                $display("  Got:      out_case=%b",
                         out_case);
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
        $dumpvars(0,clk, d, e, out_case);
    end

endmodule
