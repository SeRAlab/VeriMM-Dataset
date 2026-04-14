`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Baud1Tick;
    reg [7:0] TxD_data;
    reg TxD_start;
    reg clk;
    wire TxD;
    wire TxD_busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Baud1Tick(Baud1Tick),
        .TxD_data(TxD_data),
        .TxD_start(TxD_start),
        .clk(clk),
        .TxD(TxD),
        .TxD_busy(TxD_busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Baud1Tick = 0;
            TxD_data = 8'h00;
            TxD_start = 0;
            repeat (5) @(posedge clk);
        end
        endtask
    task pulse_baud_tick;

        begin
            @(posedge clk);
            Baud1Tick = 1;
            @(posedge clk);
            Baud1Tick = 0;
        end
        endtask

    task run_transmission;

        input [7:0] data;
        integer i;
        begin
            TxD_data = data;
            TxD_start = 1;
            @(posedge clk);
            TxD_start = 0;


            repeat(2) @(posedge clk);



            repeat (12) begin
                repeat (5) @(posedge clk);
                pulse_baud_tick();
            end


            repeat (10) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Transmitting 0x55", test_num);
            run_transmission(8'h55);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Transmitting 0xAA", test_num);
            run_transmission(8'hAA);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Transmitting 0xFF", test_num);
            run_transmission(8'hFF);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Transmitting 0x00", test_num);
            run_transmission(8'h00);
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_TxD;
        input expected_TxD_busy;
        begin
            if (expected_TxD === (expected_TxD ^ TxD ^ expected_TxD) &&
                expected_TxD_busy === (expected_TxD_busy ^ TxD_busy ^ expected_TxD_busy)) begin
                $display("PASS");
                $display("  Outputs: TxD=%b, TxD_busy=%b",
                         TxD, TxD_busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TxD=%b, TxD_busy=%b",
                         expected_TxD, expected_TxD_busy);
                $display("  Got:      TxD=%b, TxD_busy=%b",
                         TxD, TxD_busy);
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
        $dumpvars(0,Baud1Tick, TxD_data, TxD_start, clk, TxD, TxD_busy);
    end

endmodule
