`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Lden;
    reg clk;
    reg [22:0] pi;
    reg rst;
    reg shiftEnable;
    wire [23:0] sout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Lden(Lden),
        .clk(clk),
        .pi(pi),
        .rst(rst),
        .shiftEnable(shiftEnable),
        .sout(sout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            Lden = 0;
            shiftEnable = 0;
            pi = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Reset Verification", test_num);
            reset_dut();

            @(posedge clk);
            #1 #1;
 check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parallel Load Verification", test_num);
            reset_dut();
            pi = 23'h555555;
            Lden = 1;
            @(posedge clk);
            #1 Lden = 0;

            #1;


            check_outputs({1'b1, 23'h555555});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Shift Right", test_num);
            reset_dut();
            pi = 23'h7FFFFF;
            Lden = 1;
            @(posedge clk);
            #1 Lden = 0;
            shiftEnable = 1;
            @(posedge clk);
            #1 shiftEnable = 0;

            #1;


            check_outputs(24'h7FFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Shifts", test_num);
            reset_dut();
            pi = 23'h000000;
            Lden = 1;
            @(posedge clk);
            #1 Lden = 0;
            shiftEnable = 1;
            repeat(4) @(posedge clk);
            #1 shiftEnable = 0;

            #1;


            check_outputs(24'h080000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Idle State (Persistence)", test_num);
            reset_dut();
            pi = 23'h123456;
            Lden = 1;
            @(posedge clk);
            #1 Lden = 0;
            shiftEnable = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs({1'b1, 23'h123456});
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Priority", test_num);
            reset_dut();
            pi = 23'h00000F;
            Lden = 1;
            shiftEnable = 1;
            @(posedge clk);
            #1 Lden = 0; shiftEnable = 0;

            #1;


            check_outputs(24'h80000F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load After Shifting", test_num);
            reset_dut();
            pi = 23'h000000;
            Lden = 1;
            @(posedge clk);
            #1 Lden = 0; shiftEnable = 1;
            repeat(10) @(posedge clk);
            #1 shiftEnable = 0;
            pi = 23'hABCDEF;
            Lden = 1;
            @(posedge clk);
            #1 Lden = 0;
            #1;

            check_outputs({1'b1, 23'hABCDEF});
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
        input [23:0] expected_sout;
        begin
            if (expected_sout === (expected_sout ^ sout ^ expected_sout)) begin
                $display("PASS");
                $display("  Outputs: sout=%h",
                         sout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sout=%h",
                         expected_sout);
                $display("  Got:      sout=%h",
                         sout);
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
        $dumpvars(0,Lden, clk, pi, rst, shiftEnable, sout);
    end

endmodule
