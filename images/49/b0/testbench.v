`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg calculate;
    reg clk;
    reg [7:0] count;
    wire C;
    wire De;
    wire U;
    wire [3:0] centenas;
    wire [3:0] decenas;
    wire [3:0] unidades;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .calculate(calculate),
        .clk(clk),
        .count(count),
        .C(C),
        .De(De),
        .U(U),
        .centenas(centenas),
        .decenas(decenas),
        .unidades(unidades)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            calculate <= 0;
            count <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Count = 0");
            reset_dut();
            test_num = 1;
            count <= 8'd0;
            calculate <= 1;
            @(posedge clk);
            calculate <= 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Count = 7");
            reset_dut();
            test_num = 2;
            count <= 8'd7;
            calculate <= 1;
            @(posedge clk);
            calculate <= 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 4'd0, 4'd0, 4'd7);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Count = 10");
            reset_dut();
            test_num = 3;
            count <= 8'd10;
            calculate <= 1;
            @(posedge clk);
            calculate <= 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 4'd0, 4'd1, 4'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Count = 42");
            reset_dut();
            test_num = 4;
            count <= 8'd42;
            calculate <= 1;
            @(posedge clk);
            calculate <= 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 4'd0, 4'd4, 4'd2);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Count = 100");
            reset_dut();
            test_num = 5;
            count <= 8'd100;
            calculate <= 1;
            @(posedge clk);
            calculate <= 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 4'd1, 4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Count = 123");
            reset_dut();
            test_num = 6;
            count <= 8'd123;
            calculate <= 1;
            @(posedge clk);
            calculate <= 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 4'd1, 4'd2, 4'd3);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Count = 255");
            reset_dut();
            test_num = 7;
            count <= 8'd255;
            calculate <= 1;
            @(posedge clk);
            calculate <= 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 4'd2, 4'd5, 4'd5);
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
        input expected_C;
        input expected_De;
        input expected_U;
        input [3:0] expected_centenas;
        input [3:0] expected_decenas;
        input [3:0] expected_unidades;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_De === (expected_De ^ De ^ expected_De) &&
                expected_U === (expected_U ^ U ^ expected_U) &&
                expected_centenas === (expected_centenas ^ centenas ^ expected_centenas) &&
                expected_decenas === (expected_decenas ^ decenas ^ expected_decenas) &&
                expected_unidades === (expected_unidades ^ unidades ^ expected_unidades)) begin
                $display("PASS");
                $display("  Outputs: C=%b, De=%b, U=%b, centenas=%h, decenas=%h, unidades=%h",
                         C, De, U, centenas, decenas, unidades);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, De=%b, U=%b, centenas=%h, decenas=%h, unidades=%h",
                         expected_C, expected_De, expected_U, expected_centenas, expected_decenas, expected_unidades);
                $display("  Got:      C=%b, De=%b, U=%b, centenas=%h, decenas=%h, unidades=%h",
                         C, De, U, centenas, decenas, unidades);
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
        $dumpvars(0,calculate, clk, count, C, De, U, centenas, decenas, unidades);
    end

endmodule
