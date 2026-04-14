`timescale 1ns/1ps

module uart_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg tx_en;
    wire tx_serial;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_controller dut (
        .clk(clk),
        .data_in(data_in),
        .tx_en(tx_en),
        .tx_serial(tx_serial)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            tx_en = 0;
            data_in = 8'h00;
            #(CLK_PERIOD * 2);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Checking Idle State (should be High)", test_num);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Transmit 0x55, Check Bit 0 (LSB=1)", test_num);
            data_in = 8'h55;
            tx_en = 1;
            #(CLK_PERIOD);
            tx_en = 0;

            #(BIT_PERIOD * 0.5);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Transmit 0x55, Check Bit 1 (Value=0)", test_num);
            data_in = 8'h55;
            tx_en = 1;
            #(CLK_PERIOD);
            tx_en = 0;

            #(BIT_PERIOD * 1.5);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Transmit 0xAA, Check Bit 0 (LSB=0)", test_num);
            data_in = 8'hAA;
            tx_en = 1;
            #(CLK_PERIOD);
            tx_en = 0;
            #(BIT_PERIOD * 0.5);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Transmit 0xAA, Check Bit 1 (Value=1)", test_num);
            data_in = 8'hAA;
            tx_en = 1;
            #(CLK_PERIOD);
            tx_en = 0;
            #(BIT_PERIOD * 1.5);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Transmit 0x80, Check Bit 7 (MSB=1)", test_num);
            data_in = 8'h80;
            tx_en = 1;
            #(CLK_PERIOD);
            tx_en = 0;

            #(BIT_PERIOD * 7.5);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %0d: Transmit 0x00, Check Stop Bit (Value=1)", test_num);
            data_in = 8'h00;
            tx_en = 1;
            #(CLK_PERIOD);
            tx_en = 0;

            #(BIT_PERIOD * 8.5);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Testcase %0d: Verify Return to Idle (1) after transmission completes", test_num);
            data_in = 8'hFF;
            tx_en = 1;
            #(CLK_PERIOD);
            tx_en = 0;

            #(BIT_PERIOD * 10);
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_tx_serial;
        begin
            if (expected_tx_serial === (expected_tx_serial ^ tx_serial ^ expected_tx_serial)) begin
                $display("PASS");
                $display("  Outputs: tx_serial=%b",
                         tx_serial);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_serial=%b",
                         expected_tx_serial);
                $display("  Got:      tx_serial=%b",
                         tx_serial);
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
        $dumpvars(0,clk, data_in, tx_en, tx_serial);
    end

endmodule
