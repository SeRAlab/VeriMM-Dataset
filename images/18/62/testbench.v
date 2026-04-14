`timescale 1ns/1ps

module uart_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg start_tx;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_controller dut (
        .clk(clk),
        .data_in(data_in),
        .start_tx(start_tx),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start_tx = 0;
            data_in = 8'h00;
            repeat(10) @(posedge clk);
        end
        endtask
    task verify_uart_frame;

        input [7:0] data;
        integer i;
        begin

            data_in = data;
            @(posedge clk);
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;



            repeat(5) @(posedge clk);
            $display("Checking Start Bit...");
            #1;

            check_outputs(1'b0);


            for (i = 0; i < 8; i = i + 1) begin
                repeat(10) @(posedge clk);
                $display("Checking Data Bit %0d (Value: %b)...", i, data[i]);
                #1;

                check_outputs(data[i]);
            end


            repeat(10) @(posedge clk);
            $display("Checking Stop Bit...");
            #1;

            check_outputs(1'b1);


            repeat(10) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\n[Testcase 001] Transmitting 0x55 (01010101)");
            reset_dut();
            verify_uart_frame(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\n[Testcase 002] Transmitting 0xAA (10101010)");
            reset_dut();
            verify_uart_frame(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\n[Testcase 003] Transmitting 0x00 (All Zeros)");
            reset_dut();
            verify_uart_frame(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\n[Testcase 004] Transmitting 0xFF (All Ones)");
            reset_dut();
            verify_uart_frame(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\n[Testcase 005] Transmitting 0xC3 (11000011)");
            reset_dut();
            verify_uart_frame(8'hC3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_controller Testbench");
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
        $dumpvars(0,clk, data_in, start_tx, tx);
    end

endmodule
