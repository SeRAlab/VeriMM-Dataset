`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] rx_data;
    reg rx_valid;
    reg [7:0] tx_data;
    wire tx_ready;
    wire tx_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .reset(reset),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .tx_data(tx_data),
        .tx_ready(tx_ready),
        .tx_valid(tx_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        rx_data = 8'h00;
        rx_valid = 0;
        tx_data = 8'h00;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: Transmission Initiation", test_num);
        reset_dut();
        tx_data = 8'hA5;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: Basic Reception Influence", test_num);
        reset_dut();
        rx_valid = 1;
        rx_data = 8'h55;
        repeat(3) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: Transmission Completion", test_num);
        reset_dut();
        tx_data = 8'hDE;
        @(posedge clk);

        repeat(5) @(posedge clk);
        tx_data = 8'h00;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: Simultaneous Rx and Tx", test_num);
        reset_dut();
        rx_valid = 1;
        rx_data = 8'h11;
        tx_data = 8'hEE;
        @(posedge clk);
        #1;

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
        $display("ethernet_mac_controller Testbench");
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
        input expected_tx_ready;
        input expected_tx_valid;
        begin
            if (expected_tx_ready === (expected_tx_ready ^ tx_ready ^ expected_tx_ready) &&
                expected_tx_valid === (expected_tx_valid ^ tx_valid ^ expected_tx_valid)) begin
                $display("PASS");
                $display("  Outputs: tx_ready=%b, tx_valid=%b",
                         tx_ready, tx_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_ready=%b, tx_valid=%b",
                         expected_tx_ready, expected_tx_valid);
                $display("  Got:      tx_ready=%b, tx_valid=%b",
                         tx_ready, tx_valid);
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
        $dumpvars(0,clk, reset, rx_data, rx_valid, tx_data, tx_ready, tx_valid);
    end

endmodule
