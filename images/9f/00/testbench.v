`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] config_addr;
    reg [31:0] config_data;
    reg config_en;
    reg in0;
    reg in1;
    reg reset;
    wire out_3_4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .config_addr(config_addr),
        .config_data(config_data),
        .config_en(config_en),
        .in0(in0),
        .in1(in1),
        .reset(reset),
        .out_3_4(out_3_4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            config_en = 0;
            config_addr = 0;
            config_data = 0;
            in0 = 0;
            in1 = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task write_config;

        input [31:0] addr;
        input [31:0] data;
        begin
            @(posedge clk);
            config_en = 1;
            config_addr = addr;
            config_data = data;
            @(posedge clk);
            config_en = 0;
            config_addr = 0;
            config_data = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Config bit 80=1, in0=1, in1=0 -> expect 1", test_num);
            reset_dut();


            write_config(2, 32'h00010000);

            in0 = 1;
            in1 = 0;

            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Config bit 80=1, in0=0, in1=1 -> expect 0", test_num);
            reset_dut();

            write_config(2, 32'h00010000);

            in0 = 0;
            in1 = 1;

            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Config bit 80=0, in1=0, in0=1 -> expect 0", test_num);
            reset_dut();


            write_config(2, 32'h00000000);

            in0 = 1;
            in1 = 0;

            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Config bit 80=0, in1=1, in0=0 -> expect 1", test_num);
            reset_dut();

            write_config(2, 32'h00000000);

            in0 = 0;
            in1 = 1;

            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify config persistence during input toggle", test_num);
            reset_dut();


            write_config(2, 32'h00010000);

            in0 = 1; in1 = 0;
            @(posedge clk);
            in0 = 0; in1 = 1;

            repeat(2) @(posedge clk);
            #1 #1;
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
        input expected_out_3_4;
        begin
            if (expected_out_3_4 === (expected_out_3_4 ^ out_3_4 ^ expected_out_3_4)) begin
                $display("PASS");
                $display("  Outputs: out_3_4=%b",
                         out_3_4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_3_4=%b",
                         expected_out_3_4);
                $display("  Got:      out_3_4=%b",
                         out_3_4);
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
        $dumpvars(0,clk, config_addr, config_data, config_en, in0, in1, reset, out_3_4);
    end

endmodule
