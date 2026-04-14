`timescale 1ns/1ps

module uart_tx_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start_tx;
    wire tx;
    wire tx_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_tx dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start_tx(start_tx),
        .tx(tx),
        .tx_ready(tx_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start_tx = 0;
            data_in = 8'h00;
            repeat(5) @(posedge clk);
            rst = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting 0x55 (Alternating bits)", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 8'h55;
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;


            repeat(2) @(posedge clk);
            wait(tx_ready == 1);
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting 0x00 (All zeros)", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 8'h00;
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;

            repeat(2) @(posedge clk);
            wait(tx_ready == 1);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting 0xFF (All ones)", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 8'hFF;
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;

            repeat(2) @(posedge clk);
            wait(tx_ready == 1);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting 0xA5", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 8'hA5;
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;

            repeat(2) @(posedge clk);
            wait(tx_ready == 1);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify IDLE state after Reset", test_num);
            reset_dut();
            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1);
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
        input expected_tx_ready;
        begin
            if (expected_tx === (expected_tx ^ tx ^ expected_tx) &&
                expected_tx_ready === (expected_tx_ready ^ tx_ready ^ expected_tx_ready)) begin
                $display("PASS");
                $display("  Outputs: tx=%b, tx_ready=%b",
                         tx, tx_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx=%b, tx_ready=%b",
                         expected_tx, expected_tx_ready);
                $display("  Got:      tx=%b, tx_ready=%b",
                         tx, tx_ready);
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
        $dumpvars(0,clk, data_in, rst, start_tx, tx, tx_ready);
    end

endmodule
