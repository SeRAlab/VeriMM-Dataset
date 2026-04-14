`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg hlt;
    reg [15:0] pc_input;
    reg rst_n;
    reg stall;
    wire [15:0] pc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hlt(hlt),
        .pc_input(pc_input),
        .rst_n(rst_n),
        .stall(stall),
        .pc_output(pc_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            hlt = 0;
            stall = 0;
            pc_input = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Functionality", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Normal Load (hlt=0, stall=0)", test_num);
            reset_dut();

            pc_input = 16'hABCD;
            hlt = 0;
            stall = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Halt Condition (hlt=1, stall=0)", test_num);
            reset_dut();


            pc_input = 16'h1111;
            hlt = 0;
            stall = 0;
            @(posedge clk);


            pc_input = 16'h2222;
            hlt = 1;
            stall = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Stall Condition (hlt=0, stall=1)", test_num);
            reset_dut();


            pc_input = 16'hAAAA;
            hlt = 0;
            stall = 0;
            @(posedge clk);


            pc_input = 16'hBBBB;
            hlt = 0;
            stall = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Combined Halt and Stall", test_num);
            reset_dut();


            pc_input = 16'h5555;
            hlt = 0;
            stall = 0;
            @(posedge clk);


            pc_input = 16'h6666;
            hlt = 1;
            stall = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential Cycle Updates", test_num);
            reset_dut();

            pc_input = 16'h0001; hlt = 0; stall = 0; @(posedge clk);
            pc_input = 16'h0002; @(posedge clk);
            pc_input = 16'h0003; @(posedge clk);
            pc_input = 16'h0004; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Recovery from Stall", test_num);
            reset_dut();


            pc_input = 16'hDEAD; hlt = 0; stall = 1;
            @(posedge clk);


            pc_input = 16'hBEEF; stall = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hBEEF);
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
        input [15:0] expected_pc_output;
        begin
            if (expected_pc_output === (expected_pc_output ^ pc_output ^ expected_pc_output)) begin
                $display("PASS");
                $display("  Outputs: pc_output=%h",
                         pc_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_output=%h",
                         expected_pc_output);
                $display("  Got:      pc_output=%h",
                         pc_output);
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
        $dumpvars(0,clk, hlt, pc_input, rst_n, stall, pc_output);
    end

endmodule
