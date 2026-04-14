`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: MSB 8 bits = 0xFF");
            reset_dut();
            test_num = test_num + 1;
            data_in = 32'hFF_12_34_56;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: LSB 8 bits = 0x00");
            reset_dut();
            test_num = test_num + 1;
            data_in = 32'hAB_CD_EF_00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Normal Input");
            reset_dut();
            test_num = test_num + 1;
            data_in = 32'h12_34_56_78;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h1278);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Priority Check (Both conditions)");
            reset_dut();
            test_num = test_num + 1;
            data_in = 32'hFF_00_00_00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hFF00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary MSB 0xFE");
            reset_dut();
            test_num = test_num + 1;
            data_in = 32'hFE_AA_BB_CC;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFECC);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Boundary LSB 0x01");
            reset_dut();
            test_num = test_num + 1;
            data_in = 32'h77_66_55_01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h7701);
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, data_out);
    end

endmodule
