`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] pcout;
    reg rst;
    reg [3:0] state;
    wire halt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pcout(pcout),
        .rst(rst),
        .state(state),
        .halt(halt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pcout = 32'hFFFFFFFF;
            state = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Halt Activation", test_num);
            reset_dut();
            pcout = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Halt Retention", test_num);
            reset_dut();
            pcout = 32'h00000000;
            @(posedge clk);
            #1;
            pcout = 32'h12345678;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Normal Operation (No Halt)", test_num);
            reset_dut();
            pcout = 32'hAAAA5555;
            @(posedge clk);
            #1;
            pcout = 32'hBBBBCCCC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset during Halt", test_num);
            reset_dut();
            pcout = 32'h00000000;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            pcout = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: State Signal Independence", test_num);
            reset_dut();
            state = 4'b1010;
            pcout = 32'h00000000;
            @(posedge clk);
            #1;
            state = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_halt;
        begin
            if (expected_halt === (expected_halt ^ halt ^ expected_halt)) begin
                $display("PASS");
                $display("  Outputs: halt=%b",
                         halt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: halt=%b",
                         expected_halt);
                $display("  Got:      halt=%b",
                         halt);
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
        $dumpvars(0,clk, pcout, rst, state, halt);
    end

endmodule
