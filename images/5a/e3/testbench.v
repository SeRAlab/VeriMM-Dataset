`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] jmp_addrs;
    reg jmp_in;
    reg pc_en_in;
    reg rst;
    wire [5:0] addrs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .jmp_addrs(jmp_addrs),
        .jmp_in(jmp_in),
        .pc_en_in(pc_en_in),
        .rst(rst),
        .addrs(addrs)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            jmp_in = 0;
            pc_en_in = 0;
            jmp_addrs = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            pc_en_in = 1;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(6'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            jmp_addrs = 6'h2A;
            jmp_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h2A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            pc_en_in = 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(6'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            jmp_addrs = 6'd20;
            jmp_in = 1;
            @(posedge clk);
            #1;

            jmp_in = 0;
            pc_en_in = 1;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(6'd23);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            jmp_addrs = 6'd63;
            jmp_in = 1;
            @(posedge clk);
            #1;

            jmp_in = 0;
            pc_en_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            jmp_addrs = 6'h15;
            jmp_in = 1;
            pc_en_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h15);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();

            pc_en_in = 1;
            repeat(5) @(posedge clk);
            #1;

            rst = 1;
            jmp_in = 1;
            jmp_addrs = 6'h3F;
            pc_en_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'd0);
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
        input [5:0] expected_addrs;
        begin
            if (expected_addrs === (expected_addrs ^ addrs ^ expected_addrs)) begin
                $display("PASS");
                $display("  Outputs: addrs=%h",
                         addrs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addrs=%h",
                         expected_addrs);
                $display("  Got:      addrs=%h",
                         addrs);
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
        $dumpvars(0,clk, jmp_addrs, jmp_in, pc_en_in, rst, addrs);
    end

endmodule
