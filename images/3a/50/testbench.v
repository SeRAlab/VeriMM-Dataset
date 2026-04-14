`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg [7:0] rx_data;
    reg rx_data_valid;
    reg [7:0] tx_data;
    reg tx_en;
    wire rx_frame_received;
    wire tx_busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .rst_n(rst_n),
        .rx_data(rx_data),
        .rx_data_valid(rx_data_valid),
        .tx_data(tx_data),
        .tx_en(tx_en),
        .rx_frame_received(rx_frame_received),
        .tx_busy(tx_busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            rx_data = 8'h00;
            rx_data_valid = 0;
            tx_data = 8'h00;
            tx_en = 0;
            repeat(5) @(posedge clk);
            rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset and Idle State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Frame Reception", test_num);
            reset_dut();

            @(posedge clk);
            rx_data_valid = 1;
            rx_data = 8'hAA;
            @(posedge clk);
            rx_data = 8'hAB;
            @(posedge clk);
            rx_data = 8'h11;
            @(posedge clk);
            rx_data = 8'h22;
            @(posedge clk);
            rx_data_valid = 0;
            rx_data = 8'h00;


            repeat(1) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmission Busy Status", test_num);
            reset_dut();

            @(posedge clk);
            tx_en = 1;
            tx_data = 8'hDE;
            @(posedge clk);
            tx_data = 8'hAD;
            @(posedge clk);
            tx_data = 8'hBE;
            @(posedge clk);
            tx_data = 8'hEF;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Full Duplex Operation", test_num);
            reset_dut();

            @(posedge clk);
            rx_data_valid = 1;
            tx_en = 1;
            rx_data = 8'h55;
            tx_data = 8'h66;

            repeat(4) @(posedge clk);

            rx_data_valid = 0;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Post-Transmission Idle", test_num);
            reset_dut();

            @(posedge clk);
            tx_en = 1;
            repeat(2) @(posedge clk);
            tx_en = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_rx_frame_received;
        input expected_tx_busy;
        begin
            if (expected_rx_frame_received === (expected_rx_frame_received ^ rx_frame_received ^ expected_rx_frame_received) &&
                expected_tx_busy === (expected_tx_busy ^ tx_busy ^ expected_tx_busy)) begin
                $display("PASS");
                $display("  Outputs: rx_frame_received=%b, tx_busy=%b",
                         rx_frame_received, tx_busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_frame_received=%b, tx_busy=%b",
                         expected_rx_frame_received, expected_tx_busy);
                $display("  Got:      rx_frame_received=%b, tx_busy=%b",
                         rx_frame_received, tx_busy);
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
        $dumpvars(0,clk, rst_n, rx_data, rx_data_valid, tx_data, tx_en, rx_frame_received, tx_busy);
    end

endmodule
