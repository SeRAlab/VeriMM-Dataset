`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg transmit_en;
    wire ready;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .transmit_en(transmit_en),
        .ready(ready),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            transmit_en = 0;
            data_in = 8'h00;

            if (ready !== 1) begin
                @(posedge ready);
            end
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        reg [7:0] test_val;
        reg [7:0] captured;
        integer i;
        begin
            test_num = test_num + 1;
            test_val = 8'h55;
            reset_dut();
            $display("Testcase %0d: Transmitting 0x%h (LSB: 1, 0, 1, 0, 1, 0, 1, 0)", test_num, test_val);

            data_in = test_val;
            transmit_en = 1;
            @(posedge clk);
            #1;
            transmit_en = 0;



            for (i = 0; i < 8; i = i + 1) begin
                captured[i] = tx;
                @(posedge clk);
                #1;
            end


            if (!ready) @(posedge ready);
            #1;


            if (captured === test_val)
                #1;

                check_outputs(1, 1);
            else begin
                $display("  Data Mismatch! Captured: %b, Expected: %b", captured, test_val);
                #1;

                check_outputs(1, ~tx);
            end
        end
        endtask

    task testcase002;

        reg [7:0] test_val;
        reg [7:0] captured;
        integer i;
        begin
            test_num = test_num + 1;
            test_val = 8'hAA;
            reset_dut();
            $display("Testcase %0d: Transmitting 0x%h (LSB: 0, 1, 0, 1, 0, 1, 0, 1)", test_num, test_val);

            data_in = test_val;
            transmit_en = 1;
            @(posedge clk);
            #1;
            transmit_en = 0;

            for (i = 0; i < 8; i = i + 1) begin
                captured[i] = tx;
                @(posedge clk);
                #1;
            end

            if (!ready) @(posedge ready);
            #1;

            if (captured === test_val)
                #1;

                check_outputs(1, 1);
            else
                #1;

                check_outputs(1, ~tx);
        end
        endtask

    task testcase003;

        reg [7:0] test_val;
        reg [7:0] captured;
        integer i;
        begin
            test_num = test_num + 1;
            test_val = 8'h00;
            reset_dut();
            $display("Testcase %0d: Transmitting 0x%h (All 0s)", test_num, test_val);

            data_in = test_val;
            transmit_en = 1;
            @(posedge clk);
            #1;
            transmit_en = 0;

            for (i = 0; i < 8; i = i + 1) begin
                captured[i] = tx;
                @(posedge clk);
                #1;
            end

            if (!ready) @(posedge ready);
            #1;

            if (captured === test_val)
                #1;

                check_outputs(1, 1);
            else
                #1;

                check_outputs(1, ~tx);
        end
        endtask

    task testcase004;

        reg [7:0] test_val;
        reg [7:0] captured;
        integer i;
        begin
            test_num = test_num + 1;
            test_val = 8'hFF;
            reset_dut();
            $display("Testcase %0d: Transmitting 0x%h (All 1s)", test_num, test_val);

            data_in = test_val;
            transmit_en = 1;
            @(posedge clk);
            #1;
            transmit_en = 0;

            for (i = 0; i < 8; i = i + 1) begin
                captured[i] = tx;
                @(posedge clk);
                #1;
            end

            if (!ready) @(posedge ready);
            #1;

            if (captured === test_val)
                #1;

                check_outputs(1, 1);
            else
                #1;

                check_outputs(1, ~tx);
        end
        endtask

    task testcase005;

        reg [7:0] test_val;
        reg [7:0] captured;
        integer i;
        begin
            test_num = test_num + 1;
            test_val = 8'h12;
            reset_dut();
            $display("Testcase %0d: Transmitting 0x%h", test_num, test_val);

            data_in = test_val;
            transmit_en = 1;
            @(posedge clk);
            #1;
            transmit_en = 0;

            for (i = 0; i < 8; i = i + 1) begin
                captured[i] = tx;
                @(posedge clk);
                #1;
            end

            if (!ready) @(posedge ready);
            #1;

            if (captured === test_val)
                #1;

                check_outputs(1, 1);
            else
                #1;

                check_outputs(1, ~tx);
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
        input expected_ready;
        input expected_tx;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, tx=%b",
                         ready, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, tx=%b",
                         expected_ready, expected_tx);
                $display("  Got:      ready=%b, tx=%b",
                         ready, tx);
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
        $dumpvars(0,clk, data_in, transmit_en, ready, tx);
    end

endmodule
