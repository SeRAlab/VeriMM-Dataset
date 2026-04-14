`timescale 1ns/1ps

module uart_tx_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg tx_en;
    wire tx_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_tx dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .tx_en(tx_en),
        .tx_out(tx_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            tx_en = 0;
            data_in = 8'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking Idle State (Should be 1)");
            reset_dut();

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Checking Start Bit for data 0xAA");
            reset_dut();
            data_in = 8'hAA;
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Checking Bit 0 (LSB) for data 0x01");
            reset_dut();
            data_in = 8'h01;
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Checking Bit 0 (LSB) for data 0xFE");
            reset_dut();
            data_in = 8'hFE;
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Checking Bit 7 (MSB) for data 0x80");
            reset_dut();
            data_in = 8'h80;
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Checking Bit 7 (MSB) for data 0x7F");
            reset_dut();
            data_in = 8'h7F;
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Checking Stop Bit for data 0x00");
            reset_dut();
            data_in = 8'h00;
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;
            repeat(9) @(posedge clk);
            #1;
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
        $display("uart_tx Testbench");
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
        input expected_tx_out;
        begin
            if (expected_tx_out === (expected_tx_out ^ tx_out ^ expected_tx_out)) begin
                $display("PASS");
                $display("  Outputs: tx_out=%b",
                         tx_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_out=%b",
                         expected_tx_out);
                $display("  Got:      tx_out=%b",
                         tx_out);
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
        $dumpvars(0,clk, data_in, reset, tx_en, tx_out);
    end

endmodule
