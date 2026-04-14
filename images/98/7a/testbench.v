`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg LD;
    reg RST;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .LD(LD),
        .RST(RST),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            LD = 0;
            D = 4'b0000;
            #15;
            RST = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge CLK);
            LD = 1;
            D = 4'b1011;
            @(posedge CLK);
            #1; LD = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            @(negedge CLK);
            LD = 1;
            D = 4'b1000;
            @(posedge CLK);

            @(negedge CLK);
            LD = 0;
            @(posedge CLK);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(negedge CLK);
            LD = 1;
            D = 4'b1100;
            @(posedge CLK);

            @(negedge CLK);
            LD = 0;
            repeat(3) @(posedge CLK);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            @(negedge CLK);
            LD = 1;
            D = 4'b0111;
            @(posedge CLK);

            @(negedge CLK);
            LD = 1;
            D = 4'b1111;
            @(posedge CLK);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            @(negedge CLK);
            LD = 1;
            D = 4'b1111;
            @(posedge CLK);

            #3;
            RST = 1;
            #1;
            #1;

            check_outputs(4'b0000);
            RST = 0;
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            @(negedge CLK);
            LD = 0;
            repeat(2) @(posedge CLK);
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_OUT;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
        $dumpvars(0,CLK, D, LD, RST, OUT);
    end

endmodule
