`timescale 1ns/1ps

module uart_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg transmit;
    wire busy;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .transmit(transmit),
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
            rst = 1;
            transmit = 0;
            data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task run_uart_test;

        input [7:0] test_data;
        reg [9:0] captured_frame;
        reg [9:0] expected_frame;
        integer i;
        begin
            data_in = test_data;


            expected_frame = {1'b1, test_data[7], test_data[6], test_data[5], test_data[4], test_data[3], test_data[2], test_data[1], test_data[0], 1'b0};

            @(posedge clk);
            #1 transmit = 1;
            @(posedge clk);
            #1 transmit = 0;


            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                captured_frame[i] = tx;
            end


            repeat(2) @(posedge clk);



            if (captured_frame === expected_frame) begin
                #1;

                check_outputs(1'b0, 1'b1);
            end else begin
                $display("  DATA ERROR: Expected frame %b, Got %b", expected_frame, captured_frame);

                #1;


                check_outputs(!busy, !tx);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmit 0x55 (Alternating 01010101)", test_num);
            reset_dut();
            run_uart_test(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmit 0xAA (Alternating 10101010)", test_num);
            reset_dut();
            run_uart_test(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmit 0x00 (All Zeros)", test_num);
            reset_dut();
            run_uart_test(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmit 0xFF (All Ones)", test_num);
            reset_dut();
            run_uart_test(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmit 0x12 (Pattern 00010010)", test_num);
            reset_dut();
            run_uart_test(8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmit 0xBD (Pattern 10111101)", test_num);
            reset_dut();
            run_uart_test(8'hBD);
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
        $dumpvars(0,clk, data_in, rst, transmit, busy, tx);
    end

endmodule
