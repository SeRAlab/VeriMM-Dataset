`timescale 1ns/1ps

module uart_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    reg start;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
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
            rst_n = 0;
            start = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        reg [9:0] frame;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 0x55 (Alternating 1/0)", test_num);
            reset_dut();
            data_in = 8'h55;
            frame = {1'b1, 8'h55, 1'b0};

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 10; i = i + 1) begin
                #1;
                #1;

                check_outputs(frame[i]);
                @(posedge clk);
            end
        end
        endtask

    task testcase002;

        integer i;
        reg [9:0] frame;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 0xAA (Alternating 0/1)", test_num);
            reset_dut();
            data_in = 8'hAA;
            frame = {1'b1, 8'hAA, 1'b0};

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 10; i = i + 1) begin
                #1;
                #1;

                check_outputs(frame[i]);
                @(posedge clk);
            end
        end
        endtask

    task testcase003;

        integer i;
        reg [9:0] frame;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 0x00 (All Zeros)", test_num);
            reset_dut();
            data_in = 8'h00;
            frame = {1'b1, 8'h00, 1'b0};

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 10; i = i + 1) begin
                #1;
                #1;

                check_outputs(frame[i]);
                @(posedge clk);
            end
        end
        endtask

    task testcase004;

        integer i;
        reg [9:0] frame;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 0xFF (All Ones)", test_num);
            reset_dut();
            data_in = 8'hFF;
            frame = {1'b1, 8'hFF, 1'b0};

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 10; i = i + 1) begin
                #1;
                #1;

                check_outputs(frame[i]);
                @(posedge clk);
            end
        end
        endtask

    task testcase005;

        integer i;
        reg [9:0] frame;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 0xA5", test_num);
            reset_dut();
            data_in = 8'hA5;
            frame = {1'b1, 8'hA5, 1'b0};

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 10; i = i + 1) begin
                #1;
                #1;

                check_outputs(frame[i]);
                @(posedge clk);
            end
        end
        endtask

    task testcase006;

        integer i;
        reg [9:0] frame;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 0xC3", test_num);
            reset_dut();
            data_in = 8'hC3;
            frame = {1'b1, 8'hC3, 1'b0};

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 10; i = i + 1) begin
                #1;
                #1;

                check_outputs(frame[i]);
                @(posedge clk);
            end
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
        $dumpvars(0,clk, data_in, rst_n, start, tx);
    end

endmodule
