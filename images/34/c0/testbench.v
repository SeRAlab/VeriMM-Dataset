`timescale 1ns/1ps

module ethernet_mac_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg valid_in;
    wire [7:0] data_out;
    wire rx_ready;
    wire tx_busy;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid_in(valid_in),
        .data_out(data_out),
        .rx_ready(rx_ready),
        .tx_busy(tx_busy),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h0;
            valid_in = 0;
            test_num = test_num + 1;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase%03d: Initial Reset State", test_num + 1);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase%03d: Single Byte Transmission", test_num + 1);
            reset_dut();


            @(posedge clk);
            data_in = 8'hA5;
            valid_in = 1'b1;
            @(posedge clk);
            valid_in = 1'b0;


            wait(valid_out == 1'b1);


            #1;



            check_outputs(8'hA5, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase%03d: Multi-byte Packet Sequence", test_num + 1);
            reset_dut();


            @(posedge clk);
            data_in = 8'h11; valid_in = 1'b1;
            @(posedge clk);
            data_in = 8'h22; valid_in = 1'b1;
            @(posedge clk);
            data_in = 8'h33; valid_in = 1'b1;
            @(posedge clk);
            valid_in = 1'b0;


            wait(valid_out == 1'b1);

            #1;


            check_outputs(8'h11, 1'b1, 1'b1, 1'b1);


            @(posedge clk);

            if (data_out == 8'h22) $display("  Sequential check: Byte 2 matches 0x22");
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase%03d: Return to Idle Check", test_num + 1);
            reset_dut();


            @(posedge clk);
            data_in = 8'hFF;
            valid_in = 1'b1;
            @(posedge clk);
            valid_in = 1'b0;


            wait(valid_out == 1'b1);

            wait(valid_out == 1'b0);
            repeat (2) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_rx_ready;
        input expected_tx_busy;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_rx_ready === (expected_rx_ready ^ rx_ready ^ expected_rx_ready) &&
                expected_tx_busy === (expected_tx_busy ^ tx_busy ^ expected_tx_busy) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, rx_ready=%b, tx_busy=%b, valid_out=%b",
                         data_out, rx_ready, tx_busy, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, rx_ready=%b, tx_busy=%b, valid_out=%b",
                         expected_data_out, expected_rx_ready, expected_tx_busy, expected_valid_out);
                $display("  Got:      data_out=%h, rx_ready=%b, tx_busy=%b, valid_out=%b",
                         data_out, rx_ready, tx_busy, valid_out);
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
        $dumpvars(0,clk, data_in, reset, valid_in, data_out, rx_ready, tx_busy, valid_out);
    end

endmodule
