`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg [255:0] in;
    reg load;
    reg sel;
    wire out;
    wire [99:0] rotator_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .in(in),
        .load(load),
        .sel(sel),
        .out(out),
        .rotator_output(rotator_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk = 0;
            load = 1;
            ena = 2'b00;
            data = 100'b0;
            in = 256'b0;
            sel = 0;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Load and Sel=1 check", test_num);
            reset_dut();

            load = 1;
            data = 100'h5555555555555555555555555;
            in = 256'b0;
            in[255] = 1'b1;
            sel = 1'b1;

            @(posedge clk);
            #1;
            load = 0;


            #1;



            check_outputs(1'b1, 100'h5555555555555555555555555);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Logical AND check (All 1s)", test_num);
            reset_dut();

            load = 1;
            data = {100{1'b1}};
            in = 256'b0;
            in[255] = 1'b1;
            sel = 1'b0;

            @(posedge clk);
            #1;
            load = 0;


            #1;



            check_outputs(1'b1, {100{1'b1}});
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Logical AND check (One zero in rotator)", test_num);
            reset_dut();

            load = 1;
            data = {100{1'b1}};
            data[50] = 1'b0;
            in = 256'b0;
            in[255] = 1'b1;
            sel = 1'b0;

            @(posedge clk);
            #1;
            load = 0;


            #1;



            check_outputs(1'b0, data);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Logical AND check (in[255]=0)", test_num);
            reset_dut();

            load = 1;
            data = {100{1'b1}};
            in = 256'b0;
            sel = 1'b0;

            @(posedge clk);
            #1;
            load = 0;


            #1;



            check_outputs(1'b0, {100{1'b1}});
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Rotate Left (100'h1 -> 100'h2)", test_num);
            reset_dut();

            load = 1;
            data = 100'h1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b10;

            @(posedge clk);
            #1;
            ena = 2'b00;


            #1;



            check_outputs(out, 100'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Rotate Left Wrap-around", test_num);
            reset_dut();

            load = 1;

            data = 100'h8000000000000000000000000;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b10;

            @(posedge clk);
            #1;
            ena = 2'b00;


            #1;



            check_outputs(out, 100'h1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Rotate Right (100'h2 -> 100'h1)", test_num);
            reset_dut();

            load = 1;
            data = 100'h2;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;

            @(posedge clk);
            #1;
            ena = 2'b00;

            #1;


            check_outputs(out, 100'h1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Rotate Right Wrap-around", test_num);
            reset_dut();

            load = 1;
            data = 100'h1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;

            @(posedge clk);
            #1;
            ena = 2'b00;


            #1;



            check_outputs(out, 100'h8000000000000000000000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Continuous Rotate Left for 4 cycles", test_num);
            reset_dut();

            load = 1;
            data = 100'hF;
            in[255] = 1'b0;
            sel = 1'b1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b10;

            repeat(4) @(posedge clk);
            #1;
            ena = 2'b00;


            #1;



            check_outputs(1'b0, 100'hF0);
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
        testcase008();
        testcase009();
        
        
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
        input expected_out;
        input [99:0] expected_rotator_output;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_rotator_output === (expected_rotator_output ^ rotator_output ^ expected_rotator_output)) begin
                $display("PASS");
                $display("  Outputs: out=%b, rotator_output=%h",
                         out, rotator_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, rotator_output=%h",
                         expected_out, expected_rotator_output);
                $display("  Got:      out=%b, rotator_output=%h",
                         out, rotator_output);
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
        $dumpvars(0,clk, data, ena, in, load, sel, out, rotator_output);
    end

endmodule
