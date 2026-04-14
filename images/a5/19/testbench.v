`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D_i;
    reg clk_i;
    reg reset_i;
    reg wr_i;
    wire [7:0] D_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D_i(D_i),
        .clk_i(clk_i),
        .reset_i(reset_i),
        .wr_i(wr_i),
        .D_o(D_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

    begin
        reset_i = 1;
        wr_i = 0;
        D_i = 8'h00;
        @(posedge clk_i);
        #1;
        reset_i = 0;
        @(posedge clk_i);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Check", test_num);
        reset_dut();


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Write 0xAA", test_num);
        reset_dut();

        wr_i = 1;
        D_i = 8'hAA;
        @(posedge clk_i);
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Hold State Check", test_num);
        reset_dut();


        wr_i = 1;
        D_i = 8'h55;
        @(posedge clk_i);
        #1;


        wr_i = 0;
        D_i = 8'hFF;
        @(posedge clk_i);
        #1;


        #1;



        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Successive Writes", test_num);
        reset_dut();

        wr_i = 1;
        D_i = 8'h11;
        @(posedge clk_i);
        #1;

        D_i = 8'h22;
        @(posedge clk_i);
        #1;

        D_i = 8'h33;
        @(posedge clk_i);
        #1;

        #1;


        check_outputs(8'h33);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Override Check", test_num);
        reset_dut();


        reset_i = 1;
        wr_i = 1;
        D_i = 8'h99;
        @(posedge clk_i);
        #1;


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Zero Value", test_num);
        reset_dut();


        wr_i = 1;
        D_i = 8'hFF;
        @(posedge clk_i);
        #1;


        D_i = 8'h00;
        @(posedge clk_i);
        #1;

        #1;


        check_outputs(8'h00);
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
        input [7:0] expected_D_o;
        begin
            if (expected_D_o === (expected_D_o ^ D_o ^ expected_D_o)) begin
                $display("PASS");
                $display("  Outputs: D_o=%h",
                         D_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_o=%h",
                         expected_D_o);
                $display("  Got:      D_o=%h",
                         D_o);
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
        $dumpvars(0,D_i, clk_i, reset_i, wr_i, D_o);
    end

endmodule
