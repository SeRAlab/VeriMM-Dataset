`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            data_in = 8'h00;
            repeat(10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting 0x55 (D7 should be 0)", test_num);
            reset_dut();
            data_in = 8'h55;
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;



            repeat (8 * BIT_CYCLES + (BIT_CYCLES/2)) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting 0xAA (D7 should be 1)", test_num);
            reset_dut();
            data_in = 8'hAA;
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat (8 * BIT_CYCLES + (BIT_CYCLES/2)) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting 0x00 (D7 should be 0)", test_num);
            reset_dut();
            data_in = 8'h00;
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat (8 * BIT_CYCLES + (BIT_CYCLES/2)) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting 0xFF (D7 should be 1)", test_num);
            reset_dut();
            data_in = 8'hFF;
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat (8 * BIT_CYCLES + (BIT_CYCLES/2)) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting 0xC3 (D7 should be 1)", test_num);
            reset_dut();
            data_in = 8'hC3;
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat (8 * BIT_CYCLES + (BIT_CYCLES/2)) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_transmitter Testbench");
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
        input expected_tx;
        begin
            if (expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: tx=%b",
                         tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx=%b",
                         expected_tx);
                $display("  Got:      tx=%b",
                         tx);
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
        $dumpvars(0,clk, data_in, enable, tx);
    end

endmodule
