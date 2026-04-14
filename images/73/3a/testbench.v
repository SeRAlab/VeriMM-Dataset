`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] probe0;
    reg [63:0] probe1;
    wire [47:0] action_out;
    wire [15:0] device_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .probe0(probe0),
        .probe1(probe1),
        .action_out(action_out),
        .device_out(device_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            probe0 <= 64'h0;
            probe1 <= 64'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Default values with zero inputs", test_num);
            reset_dut();

            probe0 <= 64'h0;
            probe1 <= 64'h0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(48'hFFFFFFFFFFFF, 16'hFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Masking check for probe0", test_num);
            reset_dut();


            probe0 <= 64'hFFFF_FFFF_FFFF_AAAA;
            probe1 <= 64'h0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(48'hFFFFFFFFFFFF, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Masking check for probe1", test_num);
            reset_dut();

            probe0 <= 64'h0;

            probe1 <= 64'hAAAA_5555_5555_5555;

            @(posedge clk);
            #2;

            #1;


            check_outputs(48'hFFFFFFFFFFFF, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All-ones input", test_num);
            reset_dut();

            probe0 <= 64'hFFFF_FFFF_FFFF_FFFF;
            probe1 <= 64'hFFFF_FFFF_FFFF_FFFF;

            @(posedge clk);
            #2;


            #1;



            check_outputs(48'hFFFFFFFFFFFF, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive updates", test_num);
            reset_dut();


            probe0 <= 64'h1;
            probe1 <= 64'h1;
            @(posedge clk);
            #2;


            probe0 <= 64'h2;
            probe1 <= 64'h2;
            @(posedge clk);
            #2;



            #1;




            check_outputs(48'hFFFFFFFFFFFF, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary bit check (Bit 16 for P0, Bit 48 for P1)", test_num);
            reset_dut();

            probe0 <= 64'h0000_0000_0001_0000;
            probe1 <= 64'h0001_0000_0000_0000;

            @(posedge clk);
            #2;
            #1;

            check_outputs(48'hFFFFFFFFFFFF, 16'hFFFF);
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
        input [47:0] expected_action_out;
        input [15:0] expected_device_out;
        begin
            if (expected_action_out === (expected_action_out ^ action_out ^ expected_action_out) &&
                expected_device_out === (expected_device_out ^ device_out ^ expected_device_out)) begin
                $display("PASS");
                $display("  Outputs: action_out=%h, device_out=%h",
                         action_out, device_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: action_out=%h, device_out=%h",
                         expected_action_out, expected_device_out);
                $display("  Got:      action_out=%h, device_out=%h",
                         action_out, device_out);
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
        $dumpvars(0,clk, probe0, probe1, action_out, device_out);
    end

endmodule
