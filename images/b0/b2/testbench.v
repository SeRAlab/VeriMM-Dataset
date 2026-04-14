`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg reset;
    reg [1:0] sel;
    wire [3:0] out_alwaysblock;
    wire [3:0] out_assign;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .reset(reset),
        .sel(sel),
        .out_alwaysblock(out_alwaysblock),
        .out_assign(out_assign)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin
            in0 = 4'b0000;
            in1 = 4'b0000;
            in2 = 4'b0000;
            in3 = 4'b0000;
            sel = 2'b00;


            @(negedge reset);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Select in0");
            reset_dut();
            in0 = 4'hA; in1 = 4'h5; in2 = 4'h3; in3 = 4'hF;
            sel = 2'b00;

            @(posedge reset);


            @(negedge reset);
            #1;
            #1;

            check_outputs(4'hA, 4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Select in1");
            reset_dut();
            in0 = 4'h1; in1 = 4'hB; in2 = 4'h2; in3 = 4'h3;
            sel = 2'b01;
            @(posedge reset);
            @(negedge reset);
            #1;
            #1;

            check_outputs(4'hB, 4'hB);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Select in2");
            reset_dut();
            in0 = 4'hE; in1 = 4'hD; in2 = 4'hC; in3 = 4'hB;
            sel = 2'b10;
            @(posedge reset);
            @(negedge reset);
            #1;
            #1;

            check_outputs(4'hC, 4'hC);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Select in3");
            reset_dut();
            in0 = 4'h0; in1 = 4'h4; in2 = 4'h8; in3 = 4'hF;
            sel = 2'b11;
            @(posedge reset);
            @(negedge reset);
            #1;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Checking combinational vs registered behavior");
            reset_dut();
            in0 = 4'h5; sel = 2'b00;
            @(posedge reset);
            @(negedge reset);
            #1;



            in0 = 4'h9;
            #1;
            if (out_alwaysblock === 4'h9 && out_assign === 4'h5) begin
                $display("Sub-test PASS: Combinational update observed.");
            end else begin
                $display("Sub-test FAIL: Expected out_alwaysblock=9, out_assign=5.");
            end


            @(posedge reset);
            @(negedge reset);
            #1;
            #1;

            check_outputs(4'h9, 4'h9);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Reset 'activated' (high) check");
            reset_dut();
            in1 = 4'h7; sel = 2'b01;
            @(posedge reset);
            #2;

            if (out_assign === 4'h0) begin
                $display("Sub-test: out_assign is 0 while reset is high (activated).");
            end
            @(negedge reset);
            #1;

            #1;


            check_outputs(4'h7, 4'h7);
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
        input [3:0] expected_out_alwaysblock;
        input [3:0] expected_out_assign;
        begin
            if (expected_out_alwaysblock === (expected_out_alwaysblock ^ out_alwaysblock ^ expected_out_alwaysblock) &&
                expected_out_assign === (expected_out_assign ^ out_assign ^ expected_out_assign)) begin
                $display("PASS");
                $display("  Outputs: out_alwaysblock=%h, out_assign=%h",
                         out_alwaysblock, out_assign);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_alwaysblock=%h, out_assign=%h",
                         expected_out_alwaysblock, expected_out_assign);
                $display("  Got:      out_alwaysblock=%h, out_assign=%h",
                         out_alwaysblock, out_assign);
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
        $dumpvars(0,in0, in1, in2, in3, reset, sel, out_alwaysblock, out_assign);
    end

endmodule
