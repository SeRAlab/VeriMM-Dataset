`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] SDA_L;
    reg [15:0] SDA_U;
    reg SDRD0;
    wire [21:0] MA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SDA_L(SDA_L),
        .SDA_U(SDA_U),
        .SDRD0(SDRD0),
        .MA(MA)
    );

    // Clock generation (10ns period)
    initial begin
        SDRD0 = 0;
        forever #5 SDRD0 = ~SDRD0;
    end

        task reset_dut;

        begin
            SDA_L = 2'b00;
            SDA_U = 16'h0000;
            @(posedge SDRD0);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Base address mapping", test_num);
            reset_dut();
            SDA_L = 2'b00;
            SDA_U = 16'h0000;
            @(posedge SDRD0);
            #1;

            #1;


            check_outputs(22'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Dynamic bank update via SDA_L", test_num);
            reset_dut();
            SDA_L = 2'b01;
            SDA_U = 16'h1000;
            @(posedge SDRD0);
            #1;

            #1;


            check_outputs(22'h041000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Upper address range selection (0x8000)", test_num);
            reset_dut();
            SDA_L = 2'b00;
            SDA_U = 16'h8000;
            @(posedge SDRD0);
            #1;
            #1;

            check_outputs(22'h200000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Max bank and specific offset", test_num);
            reset_dut();
            SDA_L = 2'b11;
            SDA_U = 16'h4321;
            @(posedge SDRD0);
            #1;
            #1;

            check_outputs(22'h0C4321);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Maximum address boundary", test_num);
            reset_dut();
            SDA_L = 2'b11;
            SDA_U = 16'hFFFF;
            @(posedge SDRD0);
            #1;
            #1;

            check_outputs(22'h3FFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Mid-range bank switch check", test_num);
            reset_dut();
            SDA_L = 2'b10;
            SDA_U = 16'hC000;
            @(posedge SDRD0);
            #1;
            #1;

            check_outputs(22'h30C000);
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
        input [21:0] expected_MA;
        begin
            if (expected_MA === (expected_MA ^ MA ^ expected_MA)) begin
                $display("PASS");
                $display("  Outputs: MA=%h",
                         MA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MA=%h",
                         expected_MA);
                $display("  Got:      MA=%h",
                         MA);
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
        $dumpvars(0,SDA_L, SDA_U, SDRD0, MA);
    end

endmodule
