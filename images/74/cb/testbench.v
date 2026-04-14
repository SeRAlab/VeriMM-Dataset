`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg resetn;
    reg shift_in;
    reg shift_out;
    wire [7:0] dout;
    wire [7:0] free_slots;
    wire [7:0] used_slots;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .resetn(resetn),
        .shift_in(shift_in),
        .shift_out(shift_out),
        .dout(dout),
        .free_slots(free_slots),
        .used_slots(used_slots)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            din = 8'h0;
            shift_in = 0;
            shift_out = 0;
            @(posedge clk);
            #2 resetn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            din = 8'hA5;
            #2;
            #1;

            check_outputs(8'hA5, 8'd255, 8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            din = 8'hAA;
            shift_in = 1;
            @(posedge clk);
            #2 shift_in = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA, 8'd254, 8'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            din = 8'h11; shift_in = 1; @(posedge clk);

            #2 din = 8'h22; shift_in = 1; @(posedge clk);
            #2 shift_in = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h11, 8'd253, 8'd2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            din = 8'h11; shift_in = 1; @(posedge clk);
            #2 din = 8'h22; shift_in = 1; @(posedge clk);
            #2 shift_in = 0; @(posedge clk);

            #2 shift_out = 1; @(posedge clk);
            #2 shift_out = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h22, 8'd254, 8'd1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            din = 8'hFF; shift_in = 1; @(posedge clk);
            #2 shift_in = 0; @(posedge clk);
            #2 shift_out = 1; @(posedge clk);
            #2 shift_out = 0; din = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'd255, 8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            din = 8'hA1; shift_in = 1; @(posedge clk);
            #2 din = 8'hA2; shift_in = 1; @(posedge clk);
            #2 din = 8'hA3; shift_in = 1; @(posedge clk);
            #2 shift_in = 0; @(posedge clk);

            #2 shift_out = 1; @(posedge clk);
            #2 shift_out = 1; @(posedge clk);
            #2 shift_out = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA3, 8'd254, 8'd1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;

            din = 8'h55; shift_in = 1; @(posedge clk);

            #2 din = 8'h66; shift_in = 1; shift_out = 1; @(posedge clk);
            #2 shift_in = 0; shift_out = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h66, 8'd254, 8'd1);
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
        input [7:0] expected_dout;
        input [7:0] expected_free_slots;
        input [7:0] expected_used_slots;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_free_slots === (expected_free_slots ^ free_slots ^ expected_free_slots) &&
                expected_used_slots === (expected_used_slots ^ used_slots ^ expected_used_slots)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, free_slots=%h, used_slots=%h",
                         dout, free_slots, used_slots);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, free_slots=%h, used_slots=%h",
                         expected_dout, expected_free_slots, expected_used_slots);
                $display("  Got:      dout=%h, free_slots=%h, used_slots=%h",
                         dout, free_slots, used_slots);
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
        $dumpvars(0,clk, din, resetn, shift_in, shift_out, dout, free_slots, used_slots);
    end

endmodule
