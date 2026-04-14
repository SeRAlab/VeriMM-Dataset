`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Cambio;
    reg clk;
    reg [1:0] en;
    reg got_data;
    reg rst;
    wire [5:0] Cuenta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cambio(Cambio),
        .clk(clk),
        .en(en),
        .got_data(got_data),
        .rst(rst),
        .Cuenta(Cuenta)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 2'b00;
            Cambio = 8'h00;
            got_data = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            en = 2'b01;
            repeat(5) @(posedge clk);
            en = 2'b00;
            @(posedge clk);
            #1;

            check_outputs(6'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            Cambio = 8'd42;
            got_data = 1;
            @(posedge clk);
            got_data = 0;
            @(posedge clk);
            #1;

            check_outputs(6'd42);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            Cambio = 8'd10;
            got_data = 1;
            @(posedge clk);
            got_data = 0;

            en = 2'b10;
            repeat(3) @(posedge clk);
            en = 2'b00;
            @(posedge clk);
            #1;

            check_outputs(6'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            Cambio = 8'd63;
            got_data = 1;
            @(posedge clk);
            got_data = 0;
            en = 2'b01;
            @(posedge clk);
            en = 2'b00;
            @(posedge clk);
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            en = 2'b10;
            @(posedge clk);
            en = 2'b00;
            @(posedge clk);
            #1;

            check_outputs(6'd63);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            Cambio = 8'd15;
            got_data = 1;
            @(posedge clk);
            got_data = 0;
            en = 2'b00;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(6'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            Cambio = 8'hFF;
            got_data = 1;
            @(posedge clk);
            got_data = 0;
            @(posedge clk);
            #1;

            check_outputs(6'h3F);
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
        input [5:0] expected_Cuenta;
        begin
            if (expected_Cuenta === (expected_Cuenta ^ Cuenta ^ expected_Cuenta)) begin
                $display("PASS");
                $display("  Outputs: Cuenta=%h",
                         Cuenta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cuenta=%h",
                         expected_Cuenta);
                $display("  Got:      Cuenta=%h",
                         Cuenta);
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
        $dumpvars(0,Cambio, clk, en, got_data, rst, Cuenta);
    end

endmodule
