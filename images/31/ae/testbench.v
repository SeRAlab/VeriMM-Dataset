`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg start;
    wire busy;
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
        start = 0;
        data = 8'h00;
        repeat (5) @(posedge clk);
    end
        endtask
    task perform_uart_test;

        input [7:0] test_data;
        reg [9:0] expected_frame;
        reg [9:0] captured_frame;
        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            data = test_data;



            expected_frame = {1'b1, test_data[7], test_data[6], test_data[5], test_data[4],
                              test_data[3], test_data[2], test_data[1], test_data[0], 1'b0};

            $display("Test Case %03d: Sending Data 0x%h", test_num, test_data);


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            for (i = 0; i < 10; i = i + 1) begin
                @(negedge clk);
                captured_frame[i] = tx;
            end


            while (busy) @(posedge clk);
            #1;

            if (captured_frame === expected_frame) begin
                #1;

                check_outputs(0, 1);
            end else begin
                $display("  ERROR: Frame Mismatch! Expected: %b, Got: %b", expected_frame, captured_frame);
                #1;

                check_outputs(0, 1);

                pass_count = pass_count - 1;
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase001;

    begin
        perform_uart_test(8'h55);
    end
        endtask

    task testcase002;

    begin
        perform_uart_test(8'hAA);
    end
        endtask

    task testcase003;

    begin
        perform_uart_test(8'h00);
    end
        endtask

    task testcase004;

    begin
        perform_uart_test(8'hFF);
    end
        endtask

    task testcase005;

    begin
        perform_uart_test(8'hA5);
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
        $dumpvars(0,clk, data, start, busy, tx);
    end

endmodule
