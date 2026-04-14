`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg transmit_enable;
    wire transmission_complete;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .transmit_enable(transmit_enable),
        .transmission_complete(transmission_complete),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            transmit_enable = 0;
            data_in = 8'b0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Data 0x55", test_num);
            data_in = 8'h55;
            transmit_enable = 1;
            @(posedge clk);
            transmit_enable = 0;


            wait(transmission_complete == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Data 0xAA", test_num);
            data_in = 8'hAA;
            transmit_enable = 1;
            @(posedge clk);
            transmit_enable = 0;

            wait(transmission_complete == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Data 0x00", test_num);
            data_in = 8'h00;
            transmit_enable = 1;
            @(posedge clk);
            transmit_enable = 0;

            wait(transmission_complete == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Data 0xFF", test_num);
            data_in = 8'hFF;
            transmit_enable = 1;
            @(posedge clk);
            transmit_enable = 0;

            wait(transmission_complete == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Data 0x12", test_num);
            data_in = 8'h12;
            transmit_enable = 1;
            @(posedge clk);
            transmit_enable = 0;

            wait(transmission_complete == 1);
            @(posedge clk);
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
        $display("uart_transmitter Testbench");
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
        input expected_transmission_complete;
        input expected_tx;
        begin
            if (expected_transmission_complete === (expected_transmission_complete ^ transmission_complete ^ expected_transmission_complete) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: transmission_complete=%b, tx=%b",
                         transmission_complete, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: transmission_complete=%b, tx=%b",
                         expected_transmission_complete, expected_tx);
                $display("  Got:      transmission_complete=%b, tx=%b",
                         transmission_complete, tx);
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
        $dumpvars(0,clk, data_in, reset, transmit_enable, transmission_complete, tx);
    end

endmodule
