`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] DATA;
    reg LOAD;
    reg RESET;
    reg SHIFT_ENABLE;
    wire SERIAL_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA(DATA),
        .LOAD(LOAD),
        .RESET(RESET),
        .SHIFT_ENABLE(SHIFT_ENABLE),
        .SERIAL_OUT(SERIAL_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            LOAD = 0;
            DATA = 4'b0000;
            SHIFT_ENABLE = 0;
            @(posedge CLK);
            #1;
            RESET = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset and Initial Sum...");
            reset_dut();


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load 4'b0001 and Check Arithmetic...");
            reset_dut();
            DATA = 4'b0001;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SHIFT_ENABLE = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Load 4'b1010 and Check Arithmetic...");
            reset_dut();
            DATA = 4'b1010;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SHIFT_ENABLE = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Load and Shift once...");
            reset_dut();
            DATA = 4'b1111;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SHIFT_ENABLE = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Load 4'b0001 and Shift 5 times...");
            reset_dut();
            DATA = 4'b0001;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SHIFT_ENABLE = 1;

            repeat(4) @(posedge CLK);
            #1;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Mix arithmetic and shift logic...");
            reset_dut();
            DATA = 4'b0011;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SHIFT_ENABLE = 0;
            @(posedge CLK);
            #1;
            SHIFT_ENABLE = 1;
            @(posedge CLK);
            #1;
            SHIFT_ENABLE = 0;
            @(posedge CLK);
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
        input expected_SERIAL_OUT;
        begin
            if (expected_SERIAL_OUT === (expected_SERIAL_OUT ^ SERIAL_OUT ^ expected_SERIAL_OUT)) begin
                $display("PASS");
                $display("  Outputs: SERIAL_OUT=%b",
                         SERIAL_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SERIAL_OUT=%b",
                         expected_SERIAL_OUT);
                $display("  Got:      SERIAL_OUT=%b",
                         SERIAL_OUT);
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
        $dumpvars(0,CLK, DATA, LOAD, RESET, SHIFT_ENABLE, SERIAL_OUT);
    end

endmodule
