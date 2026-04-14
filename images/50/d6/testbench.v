`timescale 1ns/1ps

module uart_tx_8bit_tb;

    // Testbench signals (sequential circuit)
    reg baud_clk_en;
    reg clk;
    reg rst_n;
    reg [7:0] tx_data;
    reg tx_en;
    wire tx_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_tx_8bit dut (
        .baud_clk_en(baud_clk_en),
        .clk(clk),
        .rst_n(rst_n),
        .tx_data(tx_data),
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
            rst_n = 0;
            tx_en = 0;
            tx_data = 8'h00;
            baud_clk_en = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task pulse_baud;

        begin
            @(posedge clk);
            baud_clk_en = 1;
            @(posedge clk);
            baud_clk_en = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Power-on Reset and Idle State");
            reset_dut();
            test_num = 1;
            match = 1;

            #20;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        reg [7:0] data;
        reg [9:0] frame;
        integer i;
        begin
            $display("Testcase 002: Transmit 0x55 (01010101)");
            reset_dut();
            test_num = 2;
            data = 8'h55;
            frame = {1'b1, data, 1'b0};
            match = 1;

            @(posedge clk);
            tx_data = data;
            tx_en = 1;

            for (i = 0; i < 10; i = i + 1) begin
                pulse_baud();
                tx_en = 0;
                #1;
                if (tx_out !== frame[i]) match = 0;
            end

            repeat(2) pulse_baud();
            #1;

            check_outputs(match ? 1'b1 : ~tx_out);
        end
        endtask

    task testcase003;

        reg [7:0] data;
        reg [9:0] frame;
        integer i;
        begin
            $display("Testcase 003: Transmit 0xAA (10101010)");
            reset_dut();
            test_num = 3;
            data = 8'hAA;
            frame = {1'b1, data, 1'b0};
            match = 1;

            @(posedge clk);
            tx_data = data;
            tx_en = 1;

            for (i = 0; i < 10; i = i + 1) begin
                pulse_baud();
                tx_en = 0;
                #1;
                if (tx_out !== frame[i]) match = 0;
            end

            repeat(2) pulse_baud();
            #1;

            check_outputs(match ? 1'b1 : ~tx_out);
        end
        endtask

    task testcase004;

        reg [7:0] data;
        reg [9:0] frame;
        integer i;
        begin
            $display("Testcase 004: Transmit 0x00");
            reset_dut();
            test_num = 4;
            data = 8'h00;
            frame = {1'b1, data, 1'b0};
            match = 1;

            @(posedge clk);
            tx_data = data;
            tx_en = 1;

            for (i = 0; i < 10; i = i + 1) begin
                pulse_baud();
                tx_en = 0;
                #1;
                if (tx_out !== frame[i]) match = 0;
            end

            repeat(2) pulse_baud();
            #1;

            check_outputs(match ? 1'b1 : ~tx_out);
        end
        endtask

    task testcase005;

        reg [7:0] data;
        reg [9:0] frame;
        integer i;
        begin
            $display("Testcase 005: Transmit 0xFF");
            reset_dut();
            test_num = 5;
            data = 8'hFF;
            frame = {1'b1, data, 1'b0};
            match = 1;

            @(posedge clk);
            tx_data = data;
            tx_en = 1;

            for (i = 0; i < 10; i = i + 1) begin
                pulse_baud();
                tx_en = 0;
                #1;
                if (tx_out !== frame[i]) match = 0;
            end

            repeat(2) pulse_baud();
            #1;

            check_outputs(match ? 1'b1 : ~tx_out);
        end
        endtask

    task testcase006;

        reg [7:0] d1, d2;
        reg [9:0] f1, f2;
        integer i;
        begin
            $display("Testcase 006: Back-to-back Transmission (0x12 then 0x34)");
            reset_dut();
            test_num = 6;
            d1 = 8'h12; d2 = 8'h34;
            f1 = {1'b1, d1, 1'b0}; f2 = {1'b1, d2, 1'b0};
            match = 1;

            @(posedge clk);
            tx_data = d1;
            tx_en = 1;


            for (i = 0; i < 10; i = i + 1) begin
                pulse_baud();
                if (i == 5) begin tx_data = d2; tx_en = 1; end
                #1;
                if (tx_out !== f1[i]) match = 0;
            end


            for (i = 0; i < 10; i = i + 1) begin
                pulse_baud();
                tx_en = 0;
                #1;
                if (tx_out !== f2[i]) match = 0;
            end

            repeat(2) pulse_baud();
            #1;

            check_outputs(match ? 1'b1 : ~tx_out);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset mid-transmission");
            reset_dut();
            test_num = 7;
            match = 1;

            @(posedge clk);
            tx_data = 8'hAA;
            tx_en = 1;

            pulse_baud();
            pulse_baud();

            #5 rst_n = 0;
            #20 rst_n = 1;
            #10;


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
        $display("uart_tx_8bit Testbench");
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
        $dumpvars(0,baud_clk_en, clk, rst_n, tx_data, tx_en, tx_out);
    end

endmodule
