`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [1:0] IN;
    reg RST;
    wire Not_Equal_3;
    wire [1:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .IN(IN),
        .RST(RST),
        .Not_Equal_3(Not_Equal_3),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            RST = 1;
            IN = 2'b00;
            @(negedge CLK);
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            IN = 2'b00;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            IN = 2'b01;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            IN = 2'b10;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 2'b11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            IN = 2'b11;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            IN = 2'b00;
            RST = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 2'b01);
            RST = 0;
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
        input expected_Not_Equal_3;
        input [1:0] expected_OUT;
        begin
            if (expected_Not_Equal_3 === (expected_Not_Equal_3 ^ Not_Equal_3 ^ expected_Not_Equal_3) &&
                expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: Not_Equal_3=%b, OUT=%h",
                         Not_Equal_3, OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Not_Equal_3=%b, OUT=%h",
                         expected_Not_Equal_3, expected_OUT);
                $display("  Got:      Not_Equal_3=%b, OUT=%h",
                         Not_Equal_3, OUT);
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
        $dumpvars(0,CLK, IN, RST, Not_Equal_3, OUT);
    end

endmodule
