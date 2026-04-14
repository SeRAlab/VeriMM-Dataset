`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start_tx;
    wire [7:0] data_out;
    wire tx_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start_tx(start_tx),
        .data_out(data_out),
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
            data_in = 8'h00;
            start_tx = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Idle State Verification");
            reset_dut();
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Single Byte Transmission");
            reset_dut();

            @(posedge clk);
            data_in = 8'hA5;
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;



            while (tx_done == 0) @(posedge clk);


            #1;



            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Alternative Pattern Transmission");
            reset_dut();

            @(posedge clk);
            data_in = 8'hFF;
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;

            while (tx_done == 0) @(posedge clk);

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Sequential Transmission Check");
            reset_dut();


            @(posedge clk);
            data_in = 8'h11;
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;
            while (tx_done == 0) @(posedge clk);


            repeat(2) @(posedge clk);


            data_in = 8'h22;
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;
            while (tx_done == 0) @(posedge clk);

            #1;


            check_outputs(8'h22, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: No Start Signal Verification");
            reset_dut();

            @(posedge clk);
            data_in = 8'h55;
            start_tx = 0;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_tx_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_tx_done === (expected_tx_done ^ tx_done ^ expected_tx_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, tx_done=%b",
                         data_out, tx_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, tx_done=%b",
                         expected_data_out, expected_tx_done);
                $display("  Got:      data_out=%h, tx_done=%b",
                         data_out, tx_done);
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
        $dumpvars(0,clk, data_in, rst, start_tx, data_out, tx_done);
    end

endmodule
