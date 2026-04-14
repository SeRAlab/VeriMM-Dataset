`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] d;
    reg enabled;
    reg load;
    reg rst;
    wire [11:0] contador;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .enabled(enabled),
        .load(load),
        .rst(rst),
        .contador(contador)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            enabled = 0;
            d = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(12'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            enabled = 1;
            repeat (10) @(posedge clk);
            #1 #1;
 check_outputs(12'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            d = 12'hABC;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            d = 12'd100;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            enabled = 1;
            repeat (5) @(posedge clk);
            #1 #1;
 check_outputs(12'd105);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            enabled = 0;
            repeat (5) @(posedge clk);
            #1 #1;
 check_outputs(12'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            d = 12'd4094;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            enabled = 1;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(12'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            d = 12'hFFF;
            load = 1;
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(12'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            d = 12'h555;
            load = 1;
            enabled = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(12'h555);
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
        input [11:0] expected_contador;
        begin
            if (expected_contador === (expected_contador ^ contador ^ expected_contador)) begin
                $display("PASS");
                $display("  Outputs: contador=%h",
                         contador);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: contador=%h",
                         expected_contador);
                $display("  Got:      contador=%h",
                         contador);
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
        $dumpvars(0,clk, d, enabled, load, rst, contador);
    end

endmodule
