`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg start;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data(data),
        .start(start),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            data = 8'h00;

            repeat (2) @(posedge clk);
        end
        endtask
    task run_uart_test;

        input [7:0] test_data;
        reg [9:0] captured_frame;
        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();


            data = test_data;
            start = 1;
            @(posedge clk);
            #1 start = 0;



            for (i = 0; i < 10; i = i + 1) begin
                #1;
                captured_frame[i] = tx;
                @(posedge clk);
            end


            #5;



            $display("Test Case %0d: Transmitting 0x%h", test_num, test_data);
            if (captured_frame === {1'b1, test_data, 1'b0}) begin

                #1;


                check_outputs(tx);
            end else begin

                $display("  Error: Captured Frame %b (Expected %b)", captured_frame, {1'b1, test_data, 1'b0});
                #1;

                check_outputs(!tx);
            end
        end
        endtask

    task testcase001;

        begin
            run_uart_test(8'h55);
        end
        endtask

    task testcase002;

        begin
            run_uart_test(8'hAA);
        end
        endtask

    task testcase003;

        begin
            run_uart_test(8'h00);
        end
        endtask

    task testcase004;

        begin
            run_uart_test(8'hFF);
        end
        endtask

    task testcase005;

        begin
            run_uart_test(8'h3C);
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
        $dumpvars(0,clk, data, start, tx);
    end

endmodule
