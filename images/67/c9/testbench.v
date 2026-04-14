`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    reg [3:0] in;
    reg reset;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .in(in),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin
            VPWR = 1;
            VGND = 0;
            VPB = 1;
            VNB = 0;
            reset = 1;
            in = 4'b0000;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: in=4'b0001");
            reset_dut();
            in = 4'b0001;
            #20;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: in=4'b0010");
            reset_dut();
            in = 4'b0010;
            #20;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: in=4'b0100");
            reset_dut();
            in = 4'b0100;
            #20;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: in=4'b1000");
            reset_dut();
            in = 4'b1000;
            #20;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Unrecognized input (default)");
            reset_dut();
            in = 4'b0000;
            #20;


            #1;



            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset override check");
            reset_dut();
            in = 4'b0001;
            #10;
            reset = 1;
            #20;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Multiple bits set (unrecognized)");
            reset_dut();
            in = 4'b1111;
            #20;
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,VGND, VNB, VPB, VPWR, in, reset, out);
    end

endmodule
