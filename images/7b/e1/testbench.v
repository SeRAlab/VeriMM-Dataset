`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg [31:0] i_x;
    reg i_y;
    reg i_z;
    reg reset;
    wire [31:0] o_x;
    wire o_y;
    wire o_z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .i_x(i_x),
        .i_y(i_y),
        .i_z(i_z),
        .reset(reset),
        .o_x(o_x),
        .o_y(o_y),
        .o_z(o_z)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            i_x = 32'h0;
            i_y = 0;
            i_z = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Data Capture", test_num);
            reset_dut();

            @(negedge clock);
            enable = 1;
            i_x = 32'hDEADBEEF;
            i_y = 1'b1;
            i_z = 1'b0;

            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Data Hold (Enable=0)", test_num);
            reset_dut();


            @(negedge clock);
            enable = 1;
            i_x = 32'hAAAA5555;
            i_y = 1'b0;
            i_z = 1'b1;
            @(posedge clock);
            #1;


            @(negedge clock);
            enable = 0;
            i_x = 32'hFFFFFFFF;
            i_y = 1'b1;
            i_z = 1'b0;
            @(posedge clock);
            #2;


            #1;



            check_outputs(32'hAAAA5555, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Reset Priority over Enable", test_num);
            reset_dut();

            @(negedge clock);
            enable = 1;
            i_x = 32'h12345678;
            i_y = 1'b1;
            i_z = 1'b1;
            reset = 1;

            @(posedge clock);
            #2;


            #1;



            check_outputs(32'h00000000, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Sequential Updates", test_num);
            reset_dut();

            @(negedge clock);
            enable = 1;
            i_x = 32'h1; i_y = 1; i_z = 1;
            @(posedge clock);
            #1;

            @(negedge clock);
            i_x = 32'h2; i_y = 0; i_z = 0;
            @(posedge clock);
            #1;

            @(negedge clock);
            i_x = 32'h3; i_y = 1; i_z = 0;
            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h3, 1'b1, 1'b0);
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
        input [31:0] expected_o_x;
        input expected_o_y;
        input expected_o_z;
        begin
            if (expected_o_x === (expected_o_x ^ o_x ^ expected_o_x) &&
                expected_o_y === (expected_o_y ^ o_y ^ expected_o_y) &&
                expected_o_z === (expected_o_z ^ o_z ^ expected_o_z)) begin
                $display("PASS");
                $display("  Outputs: o_x=%h, o_y=%b, o_z=%b",
                         o_x, o_y, o_z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_x=%h, o_y=%b, o_z=%b",
                         expected_o_x, expected_o_y, expected_o_z);
                $display("  Got:      o_x=%h, o_y=%b, o_z=%b",
                         o_x, o_y, o_z);
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
        $dumpvars(0,clock, enable, i_x, i_y, i_z, reset, o_x, o_y, o_z);
    end

endmodule
