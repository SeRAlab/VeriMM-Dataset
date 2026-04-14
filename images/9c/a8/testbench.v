`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] in_vec1;
    reg [2:0] in_vec2;
    reg sel_b1;
    reg sel_b2;
    wire even_parity;
    wire [2:0] out_vec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_vec1(in_vec1),
        .in_vec2(in_vec2),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .even_parity(even_parity),
        .out_vec(out_vec)
    );

    // Clock generation (10ns period)
    initial begin
        sel_b1 = 0;
        forever #5 sel_b1 = ~sel_b1;
    end

        task reset_dut;

        begin
            in_vec1 = 3'b000;
            in_vec2 = 3'b000;
            sel_b2 = 0;
            @(posedge sel_b1);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            in_vec1 = 3'b001;
            sel_b2 = 0;
            @(posedge sel_b1);
            #2;
            $display("Test Case 001: in_vec1=3'b001, sel_b2=0");
            #1;

            check_outputs(1'b1, 3'b100);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            in_vec2 = 3'b100;
            sel_b2 = 1;
            @(posedge sel_b1);
            #2;
            $display("Test Case 002: in_vec2=3'b100, sel_b2=1");
            #1;

            check_outputs(1'b1, 3'b001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            in_vec1 = 3'b110;
            sel_b2 = 0;
            @(posedge sel_b1);
            #2;
            $display("Test Case 003: in_vec1=3'b110, sel_b2=0");
            #1;

            check_outputs(1'b0, 3'b011);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            in_vec2 = 3'b011;
            sel_b2 = 1;
            @(posedge sel_b1);
            #2;
            $display("Test Case 004: in_vec2=3'b011, sel_b2=1");
            #1;

            check_outputs(1'b0, 3'b110);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            in_vec1 = 3'b111;
            sel_b2 = 0;
            @(posedge sel_b1);
            #2;
            $display("Test Case 005: in_vec1=3'b111, sel_b2=0");
            #1;

            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            in_vec2 = 3'b000;
            sel_b2 = 1;
            @(posedge sel_b1);
            #2;
            $display("Test Case 006: in_vec2=3'b000, sel_b2=1");
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            in_vec1 = 3'b101;
            sel_b2 = 0;
            @(posedge sel_b1);
            #2;
            $display("Test Case 007: in_vec1=3'b101, sel_b2=0");
            #1;

            check_outputs(1'b0, 3'b101);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            in_vec2 = 3'b010;
            sel_b2 = 1;
            @(posedge sel_b1);
            #2;
            $display("Test Case 008: in_vec2=3'b010, sel_b2=1");
            #1;

            check_outputs(1'b1, 3'b010);
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
        input expected_even_parity;
        input [2:0] expected_out_vec;
        begin
            if (expected_even_parity === (expected_even_parity ^ even_parity ^ expected_even_parity) &&
                expected_out_vec === (expected_out_vec ^ out_vec ^ expected_out_vec)) begin
                $display("PASS");
                $display("  Outputs: even_parity=%b, out_vec=%h",
                         even_parity, out_vec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: even_parity=%b, out_vec=%h",
                         expected_even_parity, expected_out_vec);
                $display("  Got:      even_parity=%b, out_vec=%h",
                         even_parity, out_vec);
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
        $dumpvars(0,in_vec1, in_vec2, sel_b1, sel_b2, even_parity, out_vec);
    end

endmodule
