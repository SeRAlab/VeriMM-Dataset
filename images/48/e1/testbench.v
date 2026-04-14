`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg write_enable;
    reg [31:0] write_value;
    wire [31:0] Rout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .write_enable(write_enable),
        .write_value(write_value),
        .Rout(Rout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clr = 1;
        write_enable = 0;
        write_value = 0;
        #12;
        clr = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Behavior", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write Operation", test_num);
        reset_dut();
        @(posedge clk);
        write_enable = 1;
        write_value = 32'hDEADBEEF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Enable Deactivated (Hold Value)", test_num);
        reset_dut();

        @(posedge clk);
        write_enable = 1;
        write_value = 32'h12345678;
        @(posedge clk);

        write_enable = 0;
        write_value = 32'h87654321;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Asynchronous Clear Mid-Cycle", test_num);
        reset_dut();
        @(posedge clk);
        write_enable = 1;
        write_value = 32'hAAAAAAAA;
        @(posedge clk);
        #2;
        clr = 1;
        #1;
        #1;

        check_outputs(32'h0);
        clr = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Value (All 1s)", test_num);
        reset_dut();
        @(posedge clk);
        write_enable = 1;
        write_value = 32'hFFFFFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Consecutive Writes", test_num);
        reset_dut();
        write_enable = 1;
        @(posedge clk);
        write_value = 32'h00000001;
        @(posedge clk);
        write_value = 32'h00000002;
        @(posedge clk);
        write_value = 32'h00000003;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000003);
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
        input [31:0] expected_Rout;
        begin
            if (expected_Rout === (expected_Rout ^ Rout ^ expected_Rout)) begin
                $display("PASS");
                $display("  Outputs: Rout=%h",
                         Rout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Rout=%h",
                         expected_Rout);
                $display("  Got:      Rout=%h",
                         Rout);
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
        $dumpvars(0,clk, clr, write_enable, write_value, Rout);
    end

endmodule
