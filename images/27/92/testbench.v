`timescale 1ns/1ps

module ofdm_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_data;
    wire data_valid;
    wire [1:0] qpsk_symbol;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_transmitter dut (
        .clk(clk),
        .reset(reset),
        .serial_data(serial_data),
        .data_valid(data_valid),
        .qpsk_symbol(qpsk_symbol)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            serial_data = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input sequence 0, 0", test_num);
            reset_dut();

            serial_data = 0;
            @(posedge clk);
            serial_data = 0;
            @(posedge clk);


            #1;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input sequence 0, 1", test_num);
            reset_dut();

            serial_data = 0;
            @(posedge clk);
            serial_data = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input sequence 1, 0", test_num);
            reset_dut();

            serial_data = 1;
            @(posedge clk);
            serial_data = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Input sequence 1, 1", test_num);
            reset_dut();

            serial_data = 1;
            @(posedge clk);
            serial_data = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Incomplete sequence (single bit 1)", test_num);
            reset_dut();

            serial_data = 1;
            @(posedge clk);

            #1;

            #1;


            check_outputs(1'b0, qpsk_symbol);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Back-to-back symbols (01, 10)", test_num);
            reset_dut();


            serial_data = 0; @(posedge clk);
            serial_data = 1; @(posedge clk);


            serial_data = 1; @(posedge clk);
            serial_data = 0; @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_transmitter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_data_valid;
        input [1:0] expected_qpsk_symbol;
        begin
            if (expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid) &&
                expected_qpsk_symbol === (expected_qpsk_symbol ^ qpsk_symbol ^ expected_qpsk_symbol)) begin
                $display("PASS");
                $display("  Outputs: data_valid=%b, qpsk_symbol=%h",
                         data_valid, qpsk_symbol);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_valid=%b, qpsk_symbol=%h",
                         expected_data_valid, expected_qpsk_symbol);
                $display("  Got:      data_valid=%b, qpsk_symbol=%h",
                         data_valid, qpsk_symbol);
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
        $dumpvars(0,clk, reset, serial_data, data_valid, qpsk_symbol);
    end

endmodule
