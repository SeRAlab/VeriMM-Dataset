`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg sel_b1;
    reg sel_b2;
    wire out_always;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .out_always(out_always)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        d = 8'h00;
        sel_b1 = 0;
        sel_b2 = 0;

        @(negedge clk);
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture bit 0 as 1 and select it", test_num);
        reset_dut();
        d = 8'b0000_0001;
        sel_b1 = 0; sel_b2 = 0;
        @(negedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture bit 1 as 1 and select it", test_num);
        reset_dut();
        d = 8'b0000_0010;
        sel_b1 = 1; sel_b2 = 1;
        @(negedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select bit 1 when it is 0 (bit 0 is 1)", test_num);
        reset_dut();
        d = 8'b0000_0001;
        sel_b1 = 1; sel_b2 = 1;
        @(negedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select bit 0 when it is 0 (bit 1 is 1)", test_num);
        reset_dut();
        d = 8'b0000_0010;
        sel_b1 = 0; sel_b2 = 0;
        @(negedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data persistence - change 'd' after falling edge", test_num);
        reset_dut();
        d = 8'b0000_0001;
        sel_b1 = 0; sel_b2 = 0;
        @(negedge clk);
        d = 8'b0000_0000;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture and output all zeros", test_num);
        reset_dut();
        d = 8'h00;
        sel_b1 = 0; sel_b2 = 0;
        @(negedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify other bits do not affect selection", test_num);
        reset_dut();
        d = 8'b1111_1100;
        sel_b1 = 0; sel_b2 = 0;
        @(negedge clk);
        @(posedge clk);
        #1;
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
        input expected_out_always;
        begin
            if (expected_out_always === (expected_out_always ^ out_always ^ expected_out_always)) begin
                $display("PASS");
                $display("  Outputs: out_always=%b",
                         out_always);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_always=%b",
                         expected_out_always);
                $display("  Got:      out_always=%b",
                         out_always);
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
        $dumpvars(0,clk, d, sel_b1, sel_b2, out_always);
    end

endmodule
