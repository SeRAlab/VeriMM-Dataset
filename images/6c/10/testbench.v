`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg reset;
    reg wenb;
    wire [7:0] reg_0x6C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .reset(reset),
        .wenb(wenb),
        .reg_0x6C(reg_0x6C)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        wenb = 1;
        in_data = 8'h00;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Write Operation", test_num);
        reset_dut();
        wenb = 0;
        in_data = 8'hA5;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Write Disabled Check", test_num);
        reset_dut();
        wenb = 1;
        in_data = 8'hFF;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Write and Hold Check", test_num);
        reset_dut();


        wenb = 0;
        in_data = 8'h3C;
        @(posedge clk);


        #1;
        wenb = 1;
        in_data = 8'hC3;
        @(posedge clk);
        #2;


        #1;



        check_outputs(8'h3C);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Boundary Value Test (0xFF)", test_num);
        reset_dut();
        wenb = 0;
        in_data = 8'hFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Boundary Value Test (0x00)", test_num);
        reset_dut();


        wenb = 0;
        in_data = 8'hEE;
        @(posedge clk);


        #1;
        in_data = 8'h00;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Consecutive Write Operations", test_num);
        reset_dut();

        wenb = 0;
        in_data = 8'h11; @(posedge clk); #1;
        in_data = 8'h22; @(posedge clk); #1;
        in_data = 8'h33; @(posedge clk); #1;
        in_data = 8'h44; @(posedge clk); #1;

        #1;
        #1;

        check_outputs(8'h44);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Reset Priority Check", test_num);
        reset_dut();


        wenb = 0;
        in_data = 8'hAA;
        @(posedge clk);


        #1;
        reset = 1;
        in_data = 8'hBB;
        @(posedge clk);
        #2;
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
        input [7:0] expected_reg_0x6C;
        begin
            if (expected_reg_0x6C === (expected_reg_0x6C ^ reg_0x6C ^ expected_reg_0x6C)) begin
                $display("PASS");
                $display("  Outputs: reg_0x6C=%h",
                         reg_0x6C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_0x6C=%h",
                         expected_reg_0x6C);
                $display("  Got:      reg_0x6C=%h",
                         reg_0x6C);
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
        $dumpvars(0,clk, in_data, reset, wenb, reg_0x6C);
    end

endmodule
