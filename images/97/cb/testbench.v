`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clock;
    reg load;
    reg [31:0] mem_input;
    wire [31:0] memreg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clock(clock),
        .load(load),
        .mem_input(mem_input),
        .memreg(memreg)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            clear = 1;
            load = 0;
            mem_input = 0;
            @(posedge clock);
            #1;
            clear = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clear functionality", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000FF0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load data 0x12345678", test_num);
            reset_dut();
            @(negedge clock);
            clear = 0;
            load = 1;
            mem_input = 32'h12345678;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data retention when load=0", test_num);
            reset_dut();

            @(negedge clock);
            load = 1;
            mem_input = 32'hA5A5A5A5;
            @(posedge clock);
            #1;

            @(negedge clock);
            load = 0;
            mem_input = 32'hFFFFFFFF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority check (Clear vs Load)", test_num);
            reset_dut();
            @(negedge clock);
            clear = 1;
            load = 1;
            mem_input = 32'hFFFFFFFF;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h00000FF0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load all zeros", test_num);
            reset_dut();
            @(negedge clock);
            load = 1;
            mem_input = 32'h00000000;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load all ones", test_num);
            reset_dut();
            @(negedge clock);
            load = 1;
            mem_input = 32'hFFFFFFFF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successive loads", test_num);
            reset_dut();
            @(negedge clock);
            load = 1;
            mem_input = 32'hCAFEBABE;
            @(posedge clock);
            #1;
            @(negedge clock);
            mem_input = 32'hDEADBEEF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
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
        input [31:0] expected_memreg;
        begin
            if (expected_memreg === (expected_memreg ^ memreg ^ expected_memreg)) begin
                $display("PASS");
                $display("  Outputs: memreg=%h",
                         memreg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memreg=%h",
                         expected_memreg);
                $display("  Got:      memreg=%h",
                         memreg);
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
        $dumpvars(0,clear, clock, load, mem_input, memreg);
    end

endmodule
