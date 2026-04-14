`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg temp_clk;
    reg temp_en;
    reg [15:0] temp_ip;
    wire [15:0] temp_op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .temp_clk(temp_clk),
        .temp_en(temp_en),
        .temp_ip(temp_ip),
        .temp_op(temp_op)
    );

    // Clock generation (10ns period)
    initial begin
        temp_clk = 0;
        forever #5 temp_clk = ~temp_clk;
    end

        task reset_dut;

        begin
            temp_en = 0;
            temp_ip = 16'h0000;
            @(negedge temp_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Update", test_num);
            reset_dut();

            temp_en = 1;
            temp_ip = 16'hABCD;
            @(posedge temp_clk);
            #2;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Gating", test_num);
            reset_dut();


            temp_en = 1;
            temp_ip = 16'h1234;
            @(posedge temp_clk);
            #1;


            temp_en = 0;
            temp_ip = 16'hFFFF;
            @(posedge temp_clk);
            #2;


            #1;



            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values - All Ones", test_num);
            reset_dut();

            temp_en = 1;
            temp_ip = 16'hFFFF;
            @(posedge temp_clk);
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values - All Zeros", test_num);
            reset_dut();


            temp_en = 1;
            temp_ip = 16'h5555;
            @(posedge temp_clk);


            temp_ip = 16'h0000;
            @(posedge temp_clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Updates", test_num);
            reset_dut();

            temp_en = 1;
            temp_ip = 16'hAAAA;
            @(posedge temp_clk);
            #1;
            temp_ip = 16'h5555;
            @(posedge temp_clk);
            #1;
            temp_ip = 16'h1357;
            @(posedge temp_clk);
            #2;
            #1;

            check_outputs(16'h1357);
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
        input [15:0] expected_temp_op;
        begin
            if (expected_temp_op === (expected_temp_op ^ temp_op ^ expected_temp_op)) begin
                $display("PASS");
                $display("  Outputs: temp_op=%h",
                         temp_op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temp_op=%h",
                         expected_temp_op);
                $display("  Got:      temp_op=%h",
                         temp_op);
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
        $dumpvars(0,temp_clk, temp_en, temp_ip, temp_op);
    end

endmodule
