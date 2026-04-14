`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg init;
    reg [16:0] init_value;
    reg rst;
    reg [16:0] serIn;
    wire [16:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .init(init),
        .init_value(init_value),
        .rst(rst),
        .serIn(serIn),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            init = 0;
            serIn = 0;
            init_value = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(17'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Initialization Load", test_num);
            reset_dut();
            init = 1;
            init_value = 17'h0ABCD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(17'h0ABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Enable Serial Input", test_num);
            reset_dut();
            en = 1;
            serIn = 17'h15555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(17'h15555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Signed Negative Value", test_num);
            reset_dut();
            en = 1;
            serIn = -17'sd123;
            @(posedge clk);
            #1;
            #1;

            check_outputs(17'h1FF85);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Reset Priority", test_num);
            reset_dut();
            rst = 1;
            en = 1;
            init = 1;
            serIn = 17'h1FFFF;
            init_value = 17'h0AAAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(17'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Hold Value", test_num);
            reset_dut();

            en = 1;
            serIn = 17'h0F0F0;
            @(posedge clk);
            #1;

            en = 0;
            init = 0;
            serIn = 17'h00000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(17'h0F0F0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %03d: Corner Case Signed Limits", test_num);
            reset_dut();
            en = 1;
            serIn = 17'h0FFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(17'h0FFFF);

            serIn = 17'h10000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(17'h10000);
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
        input [16:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clk, en, init, init_value, rst, serIn, Q);
    end

endmodule
