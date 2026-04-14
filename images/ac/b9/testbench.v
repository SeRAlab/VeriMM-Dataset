`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg en;
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        en = 0;
        forever #5 en = ~en;
    end

        task reset_dut;

        begin
            in0 = 8'h0;
            in1 = 8'h0;
            in2 = 8'h0;
            in3 = 8'h0;
            sel = 2'b00;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing in0 selection (en=1)", test_num);
            reset_dut();
            in0 = 8'hAA; in1 = 8'hBB; in2 = 8'hCC; in3 = 8'hDD;
            sel = 2'b00;
            @(posedge en);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing in1 selection (en=1)", test_num);
            reset_dut();
            in0 = 8'h11; in1 = 8'h22; in2 = 8'h33; in3 = 8'h44;
            sel = 2'b01;
            @(posedge en);
            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing in2 selection (en=1)", test_num);
            reset_dut();
            in0 = 8'h10; in1 = 8'h20; in2 = 8'h30; in3 = 8'h40;
            sel = 2'b10;
            @(posedge en);
            #2;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing in3 selection (en=1)", test_num);
            reset_dut();
            in0 = 8'h0F; in1 = 8'hF0; in2 = 8'hCC; in3 = 8'h55;
            sel = 2'b11;
            @(posedge en);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing output latch to zero (en=0)", test_num);
            reset_dut();
            in0 = 8'hFF; in1 = 8'hFF; in2 = 8'hFF; in3 = 8'hFF;
            sel = 2'b00;
            @(negedge en);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing dynamic data change (en=1)", test_num);
            reset_dut();
            sel = 2'b10;
            in2 = 8'h5A;
            @(posedge en);
            #1;
            in2 = 8'hA5;
            #1;
            #1;

            check_outputs(8'hA5);
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
        input [7:0] expected_out;
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
        $dumpvars(0,en, in0, in1, in2, in3, sel, out);
    end

endmodule
