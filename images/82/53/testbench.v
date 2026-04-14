`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg load;
    reg loadORtxce;
    wire txbusy;
    wire txpin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .load(load),
        .loadORtxce(loadORtxce),
        .txbusy(txbusy),
        .txpin(txpin)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            loadORtxce = 0;
            d = 8'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task transmit_byte;

        input [7:0] data;
        integer i;
        begin
            d = data;
            load = 1;
            loadORtxce = 1;
            @(posedge clk);
            #1;
            load = 0;



            for (i = 0; i < 9; i = i + 1) begin
                @(posedge clk);
                #1;
            end


            loadORtxce = 0;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Transmitting 0x55", test_num);
            reset_dut();
            transmit_byte(8'h55);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Transmitting 0xAA", test_num);
            reset_dut();
            transmit_byte(8'hAA);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Transmitting 0x00", test_num);
            reset_dut();
            transmit_byte(8'h00);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Transmitting 0xFF", test_num);
            reset_dut();
            transmit_byte(8'hFF);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Transmitting 0xA5", test_num);
            reset_dut();
            transmit_byte(8'hA5);
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_txbusy;
        input expected_txpin;
        begin
            if (expected_txbusy === (expected_txbusy ^ txbusy ^ expected_txbusy) &&
                expected_txpin === (expected_txpin ^ txpin ^ expected_txpin)) begin
                $display("PASS");
                $display("  Outputs: txbusy=%b, txpin=%b",
                         txbusy, txpin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: txbusy=%b, txpin=%b",
                         expected_txbusy, expected_txpin);
                $display("  Got:      txbusy=%b, txpin=%b",
                         txbusy, txpin);
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
        $dumpvars(0,clk, d, load, loadORtxce, txbusy, txpin);
    end

endmodule
