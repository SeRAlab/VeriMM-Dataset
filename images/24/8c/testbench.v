`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg baud_rate;
    reg clk;
    reg [7:0] data;
    reg reset;
    reg start;
    wire busy;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .baud_rate(baud_rate),
        .clk(clk),
        .data(data),
        .reset(reset),
        .start(start),
        .busy(busy),
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
            start = 0;
            data = 8'b0;
            baud_rate = 1'b1;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Data = 8'h55", test_num);

            data = 8'h55;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(busy == 1);
            wait(busy == 0);


            #20;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Data = 8'hAA", test_num);

            data = 8'hAA;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(busy == 1);
            wait(busy == 0);

            #20;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Data = 8'h00", test_num);

            data = 8'h00;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(busy == 1);
            wait(busy == 0);

            #20;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Data = 8'hFF", test_num);

            data = 8'hFF;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(busy == 1);
            wait(busy == 0);

            #20;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Data = 8'hC3", test_num);

            data = 8'hC3;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(busy == 1);
            wait(busy == 0);

            #20;
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
        input expected_busy;
        input expected_tx;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, tx=%b",
                         busy, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, tx=%b",
                         expected_busy, expected_tx);
                $display("  Got:      busy=%b, tx=%b",
                         busy, tx);
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
        $dumpvars(0,baud_rate, clk, data, reset, start, busy, tx);
    end

endmodule
