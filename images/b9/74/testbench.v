`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Decenas;
    reg Disp_Enable;
    reg [7:0] Estado;
    reg [7:0] Unidades;
    reg clk_disp;
    reg rst;
    wire [7:0] Anodo;
    wire Catodo;
    wire [3:0] Seleccion;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Decenas(Decenas),
        .Disp_Enable(Disp_Enable),
        .Estado(Estado),
        .Unidades(Unidades),
        .clk_disp(clk_disp),
        .rst(rst),
        .Anodo(Anodo),
        .Catodo(Catodo),
        .Seleccion(Seleccion)
    );

    // Clock generation (10ns period)
    initial begin
        clk_disp = 0;
        forever #5 clk_disp = ~clk_disp;
    end

        task reset_dut;

    begin
        rst = 1;
        Disp_Enable = 0;
        Unidades = 8'h11;
        Decenas  = 8'h22;
        Estado   = 8'h33;
        repeat(2) @(posedge clk_disp);
        #2 rst = 0;
        @(posedge clk_disp);
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning testcase001: Reset State Check");
        reset_dut();

        #1;


        check_outputs(8'h11, 1'b0, 4'b1110);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Transition to Decenas");
        reset_dut();
        Disp_Enable = 1;
        @(posedge clk_disp);
        #1;

        check_outputs(8'h22, 1'b0, 4'b1101);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Transition to Estado");
        reset_dut();
        Disp_Enable = 1;
        repeat(2) @(posedge clk_disp);
        #1;

        check_outputs(8'h33, 1'b0, 4'b1011);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Wrap-around to Unidades");
        reset_dut();
        Disp_Enable = 1;
        repeat(3) @(posedge clk_disp);
        #1;

        check_outputs(8'h11, 1'b0, 4'b1110);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Disable Logic Check");
        reset_dut();
        Disp_Enable = 1;
        @(posedge clk_disp);
        Disp_Enable = 0;
        repeat(3) @(posedge clk_disp);
        #1;

        check_outputs(8'h22, 1'b0, 4'b1101);
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
        input [7:0] expected_Anodo;
        input expected_Catodo;
        input [3:0] expected_Seleccion;
        begin
            if (expected_Anodo === (expected_Anodo ^ Anodo ^ expected_Anodo) &&
                expected_Catodo === (expected_Catodo ^ Catodo ^ expected_Catodo) &&
                expected_Seleccion === (expected_Seleccion ^ Seleccion ^ expected_Seleccion)) begin
                $display("PASS");
                $display("  Outputs: Anodo=%h, Catodo=%b, Seleccion=%h",
                         Anodo, Catodo, Seleccion);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Anodo=%h, Catodo=%b, Seleccion=%h",
                         expected_Anodo, expected_Catodo, expected_Seleccion);
                $display("  Got:      Anodo=%h, Catodo=%b, Seleccion=%h",
                         Anodo, Catodo, Seleccion);
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
        $dumpvars(0,Decenas, Disp_Enable, Estado, Unidades, clk_disp, rst, Anodo, Catodo, Seleccion);
    end

endmodule
