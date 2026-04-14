`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg start_tx;
    wire [7:0] tx_data;
    wire tx_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .start_tx(start_tx),
        .tx_data(tx_data),
        .tx_valid(tx_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start_tx = 1'b0;
            data_in = 8'h00;

            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Checking Idle State...", test_num);
            reset_dut();

            @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Checking Transmission Initiation...", test_num);
            reset_dut();
            @(posedge clk);
            start_tx = 1'b1;
            data_in = 8'hAA;
            @(posedge clk);

            #1;


            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Checking Data Integrity...", test_num);
            reset_dut();
            @(posedge clk);
            start_tx = 1'b1;
            data_in = 8'h55;
            @(posedge clk);
            data_in = 8'hBE;
            @(posedge clk);

            #1;


            check_outputs(8'hBE, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Checking Transmission Termination...", test_num);
            reset_dut();
            @(posedge clk);
            start_tx = 1'b1;
            data_in = 8'hDE;
            @(posedge clk);
            start_tx = 1'b0;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Checking Successive Frame Handshaking...", test_num);
            reset_dut();

            start_tx = 1'b1;
            data_in = 8'h11;
            @(posedge clk);
            start_tx = 1'b0;
            @(posedge clk);

            start_tx = 1'b1;
            data_in = 8'h22;
            @(posedge clk);

            #1;


            check_outputs(8'h22, 1'b1);
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
        input [7:0] expected_tx_data;
        input expected_tx_valid;
        begin
            if (expected_tx_data === (expected_tx_data ^ tx_data ^ expected_tx_data) &&
                expected_tx_valid === (expected_tx_valid ^ tx_valid ^ expected_tx_valid)) begin
                $display("PASS");
                $display("  Outputs: tx_data=%h, tx_valid=%b",
                         tx_data, tx_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_data=%h, tx_valid=%b",
                         expected_tx_data, expected_tx_valid);
                $display("  Got:      tx_data=%h, tx_valid=%b",
                         tx_data, tx_valid);
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
        $dumpvars(0,clk, data_in, start_tx, tx_data, tx_valid);
    end

endmodule
