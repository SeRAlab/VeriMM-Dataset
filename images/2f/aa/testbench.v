`timescale 1ns/1ps

module uart_tx_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg tx_en;
    wire tx;
    wire tx_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_tx dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .tx_en(tx_en),
        .tx(tx),
        .tx_done(tx_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            tx_en = 0;
            data_in = 8'h00;
            repeat(10) @(posedge clk);
            rst = 0;
            repeat(10) @(posedge clk);
        end
        endtask
    task monitor_and_verify;

        input [7:0] expected_data;
        reg [7:0] sampled_data;
        integer i;
        begin

            @(negedge tx);


            #(BIT_PERIOD_NS * 1.5);

            for (i = 0; i < 8; i = i + 1) begin
                sampled_data[i] = tx;
                #(BIT_PERIOD_NS);
            end


            wait(tx_done);




            if (sampled_data === expected_data) begin
                $display("  Data verified: 8'h%h", sampled_data);
                #1;

                check_outputs(1'b1, 1'b1);
            end else begin
                $display("  DATA ERROR: Sent 8'h%h, Captured 8'h%h", expected_data, sampled_data);
                #1;

                check_outputs(1'b1, 1'b0);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmitting 0x55", test_num);
            reset_dut();
            data_in = 8'h55;
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;
            monitor_and_verify(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmitting 0xAA", test_num);
            reset_dut();
            data_in = 8'hAA;
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;
            monitor_and_verify(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmitting 0x00", test_num);
            reset_dut();
            data_in = 8'h00;
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;
            monitor_and_verify(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmitting 0xFF", test_num);
            reset_dut();
            data_in = 8'hFF;
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;
            monitor_and_verify(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmitting 0xA5", test_num);
            reset_dut();
            data_in = 8'hA5;
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;
            monitor_and_verify(8'hA5);
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
        input expected_tx_done;
        begin
            if (expected_tx === (expected_tx ^ tx ^ expected_tx) &&
                expected_tx_done === (expected_tx_done ^ tx_done ^ expected_tx_done)) begin
                $display("PASS");
                $display("  Outputs: tx=%b, tx_done=%b",
                         tx, tx_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx=%b, tx_done=%b",
                         expected_tx, expected_tx_done);
                $display("  Got:      tx=%b, tx_done=%b",
                         tx, tx_done);
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
        $dumpvars(0,clk, data_in, rst, tx_en, tx, tx_done);
    end

endmodule
