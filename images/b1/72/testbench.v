`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg LOAD;
    wire [5:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .LOAD(LOAD),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            LOAD = 1;
            D = 0;
            @(posedge CLK);
            #1;
            LOAD = 0;
            D = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(negedge CLK);
            LOAD = 1;
            D = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(6'b111111);
        end
        endtask

    task testcase002;

        begin

            @(negedge CLK);
            LOAD = 1;
            D = 1;
            @(posedge CLK);
            #1;

            @(negedge CLK);
            LOAD = 1;
            D = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge CLK);
            LOAD = 0;
            D = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(6'b000001);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge CLK);
            LOAD = 0; D = 1;
            @(posedge CLK);
            #1;
            @(negedge CLK);
            D = 0;
            @(posedge CLK);
            #1;
            @(negedge CLK);
            D = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(6'b000101);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            @(negedge CLK);
            LOAD = 0;
            D = 1;
            for (i = 0; i < 6; i = i + 1) begin
                @(posedge CLK);
                #1;
                @(negedge CLK);
            end
            #1;

            check_outputs(6'b111111);
        end
        endtask

    task testcase006;

        begin

            @(negedge CLK);
            LOAD = 1; D = 1;
            @(posedge CLK);
            #1;

            @(negedge CLK);
            LOAD = 0; D = 0;
            @(posedge CLK);
            #1;
            @(negedge CLK);
            D = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(6'b111100);
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
        input [5:0] expected_Q;
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
        $dumpvars(0,CLK, D, LOAD, Q);
    end

endmodule
