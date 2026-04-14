`timescale 1ns/1ps

module uart_tx_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg tx_en;
    wire busy;
    wire tx;

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
        .busy(busy),
        .tx(tx)
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
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
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
            #1 tx_en = 0;


            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);

            #1;


            check_outputs(0, 1);
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
            #1 tx_en = 0;

            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);

            #1;


            check_outputs(0, 1);
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
            #1 tx_en = 0;

            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);

            #1;


            check_outputs(0, 1);
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
            #1 tx_en = 0;

            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Back-to-back Transmission (0x12 then 0x34)", test_num);
            reset_dut();


            data_in = 8'h12;
            tx_en = 1;
            @(posedge clk);
            #1 tx_en = 0;
            wait(busy == 0);


            @(posedge clk);
            data_in = 8'h34;
            tx_en = 1;
            @(posedge clk);
            #1 tx_en = 0;
            wait(busy == 0);
            @(posedge clk);

            #1;


            check_outputs(0, 1);
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
        input expected_busy;
        input expected_tx;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, tx=%b",
                         busy, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, tx=%b",
                         expected_busy, expected_tx);
                $display("  Got:      busy=%b, tx=%b",
                         busy, tx);
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
        $dumpvars(0,clk, data_in, rst, tx_en, busy, tx);
    end

endmodule
