`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg DMA_MODE;
    reg FIFO_EN;
    reg [7:0] data_in_1;
    reg [7:0] data_in_2;
    reg m_clk;
    reg reset;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DMA_MODE(DMA_MODE),
        .FIFO_EN(FIFO_EN),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .m_clk(m_clk),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        m_clk = 0;
        forever #5 m_clk = ~m_clk;
    end

        task reset_dut;

        begin
            reset = 1;
            FIFO_EN = 0;
            DMA_MODE = 0;
            data_in_1 = 8'h00;
            data_in_2 = 8'h00;
            @(posedge m_clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Reset Check");
            reset = 1;
            data_in_1 = 8'hFF;
            data_in_2 = 8'hAA;
            @(posedge m_clk);
            #1;
            #1;

            check_outputs(8'h00);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: data_in_1 selection (0,0)");
            reset_dut();
            data_in_1 = 8'hA1;
            data_in_2 = 8'hB2;
            FIFO_EN = 0;
            DMA_MODE = 0;
            @(posedge m_clk);
            #1;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: data_in_1 selection (1,0)");
            reset_dut();
            data_in_1 = 8'hC3;
            data_in_2 = 8'hD4;
            FIFO_EN = 1;
            DMA_MODE = 0;
            @(posedge m_clk);
            #1;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: data_in_1 selection (0,1)");
            reset_dut();
            data_in_1 = 8'hE5;
            data_in_2 = 8'hF6;
            FIFO_EN = 0;
            DMA_MODE = 1;
            @(posedge m_clk);
            #1;
            #1;

            check_outputs(8'hE5);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: data_in_2 selection (1,1)");
            reset_dut();
            data_in_1 = 8'h11;
            data_in_2 = 8'h22;
            FIFO_EN = 1;
            DMA_MODE = 1;
            @(posedge m_clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Synchronous Reset Priority");
            reset_dut();
            data_in_1 = 8'h55;
            data_in_2 = 8'hAA;
            FIFO_EN = 1;
            DMA_MODE = 1;
            @(posedge m_clk);
            #1;

            if (data_out !== 8'hAA) $display("Setup error in testcase006");

            reset = 1;
            @(posedge m_clk);
            #1;
            #1;

            check_outputs(8'h00);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Dynamic data change (DMA Mode Active)");
            reset_dut();
            FIFO_EN = 1;
            DMA_MODE = 1;
            data_in_2 = 8'h33;
            @(posedge m_clk);
            #1;
            data_in_2 = 8'h44;
            @(posedge m_clk);
            #1;
            #1;

            check_outputs(8'h44);
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,DMA_MODE, FIFO_EN, data_in_1, data_in_2, m_clk, reset, data_out);
    end

endmodule
