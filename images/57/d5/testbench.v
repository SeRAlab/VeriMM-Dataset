`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg TCK;
    reg TCS;
    reg TDI;
    wire [7:0] oRxD_DATA;
    wire oRxD_Ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .TCK(TCK),
        .TCS(TCS),
        .TDI(TDI),
        .oRxD_DATA(oRxD_DATA),
        .oRxD_Ready(oRxD_Ready)
    );

    // Clock generation (10ns period)
    initial begin
        TCK = 0;
        forever #5 TCK = ~TCK;
    end

        task reset_dut;

        begin
            TCS = 1;
            TDI = 0;
            repeat (2) @(posedge TCK);
            #1;
        end
        endtask
    task send_byte;

        input [7:0] data;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                TDI = data[i];
                @(posedge TCK);
                #1;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            TCS = 0;
            send_byte(8'hA5);
            #1;

            check_outputs(8'hA5, 1'b1);
            TCS = 1;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            TCS = 0;
            send_byte(8'h5A);
            #1;

            check_outputs(8'h5A, 1'b1);
            TCS = 1;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            TCS = 0;
            send_byte(8'h00);
            #1;

            check_outputs(8'h00, 1'b1);
            TCS = 1;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            TCS = 0;
            send_byte(8'hFF);
            #1;

            check_outputs(8'hFF, 1'b1);
            TCS = 1;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            TCS = 0;
            TDI = 1; @(posedge TCK);
            TDI = 1; @(posedge TCK);
            TDI = 0; @(posedge TCK);
            TDI = 0; @(posedge TCK);
            TCS = 1;
            #20;
            TCS = 0;
            send_byte(8'h12);
            #1;

            check_outputs(8'h12, 1'b1);
            TCS = 1;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            TCS = 0;
            send_byte(8'hAA);
            send_byte(8'h55);
            #1;

            check_outputs(8'h55, 1'b1);
            TCS = 1;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            TCS = 0;
            send_byte(8'h33);
            #1;

            check_outputs(8'h33, 1'b1);
            TCS = 1;
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            TCS = 1;
            repeat (5) @(posedge TCK);
            #1;

            check_outputs(oRxD_DATA, 1'b0);
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
        input [7:0] expected_oRxD_DATA;
        input expected_oRxD_Ready;
        begin
            if (expected_oRxD_DATA === (expected_oRxD_DATA ^ oRxD_DATA ^ expected_oRxD_DATA) &&
                expected_oRxD_Ready === (expected_oRxD_Ready ^ oRxD_Ready ^ expected_oRxD_Ready)) begin
                $display("PASS");
                $display("  Outputs: oRxD_DATA=%h, oRxD_Ready=%b",
                         oRxD_DATA, oRxD_Ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oRxD_DATA=%h, oRxD_Ready=%b",
                         expected_oRxD_DATA, expected_oRxD_Ready);
                $display("  Got:      oRxD_DATA=%h, oRxD_Ready=%b",
                         oRxD_DATA, oRxD_Ready);
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
        $dumpvars(0,TCK, TCS, TDI, oRxD_DATA, oRxD_Ready);
    end

endmodule
