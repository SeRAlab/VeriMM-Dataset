`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RSTn;
    reg [7:0] RX_Data;
    reg RX_Done_Sig;
    wire RX_En_Sig;
    wire [7:0] data_tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RSTn(RSTn),
        .RX_Data(RX_Data),
        .RX_Done_Sig(RX_Done_Sig),
        .RX_En_Sig(RX_En_Sig),
        .data_tx(data_tx)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RSTn = 0;
            RX_Done_Sig = 0;
            RX_Data = 0;
            #15;
            RSTn = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial state after reset");
            reset_dut();
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Capture 8'hA5");
            reset_dut();
            @(negedge CLK);
            RX_Data = 8'hA5;
            RX_Done_Sig = 1;
            @(posedge CLK);
            #1;

            RX_Done_Sig = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Capture 8'h3C");
            reset_dut();
            @(negedge CLK);
            RX_Data = 8'h3C;
            RX_Done_Sig = 1;
            @(posedge CLK);
            #1;
            RX_Done_Sig = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 8'h3C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Data stability when RX_Done_Sig is low");
            reset_dut();

            @(negedge CLK);
            RX_Data = 8'h77;
            RX_Done_Sig = 1;
            @(posedge CLK);
            #1;
            RX_Done_Sig = 0;

            @(negedge CLK);
            RX_Data = 8'hFF;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 8'h77);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: RX_En_Sig logic during reception");
            reset_dut();
            @(negedge CLK);
            RX_Data = 8'hBB;
            RX_Done_Sig = 1;
            #2;

            #1;


            check_outputs(1'b0, 8'h00);
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
        input expected_RX_En_Sig;
        input [7:0] expected_data_tx;
        begin
            if (expected_RX_En_Sig === (expected_RX_En_Sig ^ RX_En_Sig ^ expected_RX_En_Sig) &&
                expected_data_tx === (expected_data_tx ^ data_tx ^ expected_data_tx)) begin
                $display("PASS");
                $display("  Outputs: RX_En_Sig=%b, data_tx=%h",
                         RX_En_Sig, data_tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RX_En_Sig=%b, data_tx=%h",
                         expected_RX_En_Sig, expected_data_tx);
                $display("  Got:      RX_En_Sig=%b, data_tx=%h",
                         RX_En_Sig, data_tx);
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
        $dumpvars(0,CLK, RSTn, RX_Data, RX_Done_Sig, RX_En_Sig, data_tx);
    end

endmodule
