`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] accion;
    reg clk;
    reg [1:0] piso;
    reg puertas;
    reg rst;
    wire [3:0] BCD1;
    wire [3:0] BCD2;
    wire [3:0] BCD3;
    wire [3:0] BCD4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .accion(accion),
        .clk(clk),
        .piso(piso),
        .puertas(puertas),
        .rst(rst),
        .BCD1(BCD1),
        .BCD2(BCD2),
        .BCD3(BCD3),
        .BCD4(BCD4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            #15;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            piso = 2'b00;
            accion = 2'b00;
            puertas = 1'b0;
            reset_dut();
            @(posedge clk);

            #1;


            check_outputs(4'h1, 4'hE, 4'hC, 4'hC);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            piso = 2'b01;
            accion = 2'b01;
            puertas = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(4'h2, 4'h5, 4'hC, 4'hC);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            piso = 2'b10;
            accion = 2'b00;
            puertas = 1'b1;
            @(posedge clk);
            #1;

            check_outputs(4'h3, 4'hE, 4'hA, 4'hA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            piso = 2'b11;
            accion = 2'b10;
            puertas = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(4'h4, 4'hB, 4'hC, 4'hC);
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
        input [3:0] expected_BCD1;
        input [3:0] expected_BCD2;
        input [3:0] expected_BCD3;
        input [3:0] expected_BCD4;
        begin
            if (expected_BCD1 === (expected_BCD1 ^ BCD1 ^ expected_BCD1) &&
                expected_BCD2 === (expected_BCD2 ^ BCD2 ^ expected_BCD2) &&
                expected_BCD3 === (expected_BCD3 ^ BCD3 ^ expected_BCD3) &&
                expected_BCD4 === (expected_BCD4 ^ BCD4 ^ expected_BCD4)) begin
                $display("PASS");
                $display("  Outputs: BCD1=%h, BCD2=%h, BCD3=%h, BCD4=%h",
                         BCD1, BCD2, BCD3, BCD4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD1=%h, BCD2=%h, BCD3=%h, BCD4=%h",
                         expected_BCD1, expected_BCD2, expected_BCD3, expected_BCD4);
                $display("  Got:      BCD1=%h, BCD2=%h, BCD3=%h, BCD4=%h",
                         BCD1, BCD2, BCD3, BCD4);
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
        $dumpvars(0,accion, clk, piso, puertas, rst, BCD1, BCD2, BCD3, BCD4);
    end

endmodule
