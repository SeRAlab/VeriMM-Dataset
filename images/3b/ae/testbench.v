`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg enable;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data(data),
        .enable(enable),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            data = 8'h00;
            bit_error = 0;
            captured_data = 8'h00;
            repeat(5) @(posedge clk);
            $display("\n--- Starting Test Case %0d ---", test_num + 1);
        end
        endtask
    task monitor_uart;

        input [7:0] expected_val;
        integer i;
        begin
            bit_error = 0;

            wait(tx == 0);


            #(BIT_TIME / 2);
            if (tx !== 0) begin
                $display("  ERROR: Invalid Start Bit");
                bit_error = 1;
            end


            for (i = 0; i < 8; i = i + 1) begin
                #(BIT_TIME);
                captured_data[i] = tx;
            end


            #(BIT_TIME);
            if (tx !== 1'b1) begin
                $display("  ERROR: Invalid Stop Bit");
                bit_error = 1;
            end


            if (captured_data !== expected_val) begin
                $display("  ERROR: Data Mismatch. Expected: %h, Got: %h", expected_val, captured_data);
                bit_error = 1;
            end


            #(BIT_TIME);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data = 8'h55;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            monitor_uart(8'h55);


            #1;



            check_outputs(bit_error ? ~tx : tx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data = 8'hAA;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            monitor_uart(8'hAA);
            #1;

            check_outputs(bit_error ? ~tx : tx);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 8'h00;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            monitor_uart(8'h00);
            #1;

            check_outputs(bit_error ? ~tx : tx);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 8'hFF;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            monitor_uart(8'hFF);
            #1;

            check_outputs(bit_error ? ~tx : tx);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 8'hA5;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            monitor_uart(8'hA5);
            #1;

            check_outputs(bit_error ? ~tx : tx);
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
        input expected_tx;
        begin
            if (expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: tx=%b",
                         tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx=%b",
                         expected_tx);
                $display("  Got:      tx=%b",
                         tx);
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
        $dumpvars(0,clk, data, enable, tx);
    end

endmodule
