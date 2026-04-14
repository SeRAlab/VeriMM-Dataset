`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg [31:0] i_x;
    reg [31:0] i_y;
    reg [31:0] i_z;
    reg reset;
    wire [31:0] o_x;
    wire [31:0] o_y;
    wire [31:0] o_z;

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
            i_y = 32'h0;
            i_z = 32'h0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset_dut();


            i_x = 32'hFFFF_FFFF;
            i_y = 32'hEEEE_EEEE;
            i_z = 32'hDDDD_DDDD;
            enable = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic capture (Enable=1)", test_num);
            reset_dut();

            i_x = 32'h1234_5678;
            i_y = 32'h8765_4321;
            i_z = 32'hABCD_EF01;
            enable = 1;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h1234_5678, 32'h8765_4321, 32'hABCD_EF01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold functionality (Enable=0)", test_num);
            reset_dut();


            i_x = 32'hAAAA_AAAA;
            i_y = 32'hBBBB_BBBB;
            i_z = 32'hCCCC_CCCC;
            enable = 1;
            @(posedge clock);
            #1;


            i_x = 32'h1111_1111;
            i_y = 32'h2222_2222;
            i_z = 32'h3333_3333;
            enable = 0;
            @(posedge clock);
            #1;


            #1;



            check_outputs(32'hAAAA_AAAA, 32'hBBBB_BBBB, 32'hCCCC_CCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successive updates", test_num);
            reset_dut();

            enable = 1;


            i_x = 32'h0000_0001; i_y = 32'h0000_0002; i_z = 32'h0000_0003;
            @(posedge clock);
            #1;


            i_x = 32'h0000_0010; i_y = 32'h0000_0020; i_z = 32'h0000_0030;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h0000_0010, 32'h0000_0020, 32'h0000_0030);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-operation reset", test_num);
            reset_dut();


            i_x = 32'h5555_5555; i_y = 32'h6666_6666; i_z = 32'h7777_7777;
            enable = 1;
            @(posedge clock);
            #1;


            reset = 1;
            @(posedge clock);
            #1;
            reset = 0;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0);
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
        input [31:0] expected_o_y;
        input [31:0] expected_o_z;
        begin
            if (expected_o_x === (expected_o_x ^ o_x ^ expected_o_x) &&
                expected_o_y === (expected_o_y ^ o_y ^ expected_o_y) &&
                expected_o_z === (expected_o_z ^ o_z ^ expected_o_z)) begin
                $display("PASS");
                $display("  Outputs: o_x=%h, o_y=%h, o_z=%h",
                         o_x, o_y, o_z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_x=%h, o_y=%h, o_z=%h",
                         expected_o_x, expected_o_y, expected_o_z);
                $display("  Got:      o_x=%h, o_y=%h, o_z=%h",
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
