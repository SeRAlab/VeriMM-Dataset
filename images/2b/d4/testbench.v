`timescale 1ns/1ps

module uart_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg start;
    wire ready;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_controller dut (
        .clk(clk),
        .data_in(data_in),
        .start(start),
        .ready(ready),
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
            data_in = 8'h00;
            repeat(5) @(posedge clk);
            #1;

            if (ready !== 1) begin
                wait(ready === 1);
                #1;
            end
        end
        endtask
    task testcase001;

        reg [9:0] captured_frame;
        integer i;
        reg error;
        begin
            test_num = test_num + 1;
            error = 0;
            $display("\nTestcase %0d: Transmitting 0x55 (LSB first: 1,0,1,0,1,0,1,0)", test_num);
            reset_dut();

            data_in = 8'h55;
            @(posedge clk) #1 start = 1;
            @(posedge clk) #1 start = 0;


            for (i = 0; i < 10; i = i + 1) begin
                captured_frame[i] = tx;
                @(posedge clk);
            end


            if (captured_frame !== 10'b1010101010) begin
                $display("  ERROR: Serial stream mismatch! Got: %b", captured_frame);
                error = 1;
            end

            wait(ready === 1);
            #1;


            if (error) #1;
 check_outputs(1, ~tx);
            else #1;
 check_outputs(1, 1);
        end
        endtask

    task testcase002;

        reg [9:0] captured_frame;
        integer i;
        reg error;
        begin
            test_num = test_num + 1;
            error = 0;
            $display("\nTestcase %0d: Transmitting 0xAA (LSB first: 0,1,0,1,0,1,0,1)", test_num);
            reset_dut();

            data_in = 8'hAA;
            @(posedge clk) #1 start = 1;
            @(posedge clk) #1 start = 0;

            for (i = 0; i < 10; i = i + 1) begin
                captured_frame[i] = tx;
                @(posedge clk);
            end


            if (captured_frame !== 10'b1101010100) begin
                $display("  ERROR: Serial stream mismatch! Got: %b", captured_frame);
                error = 1;
            end

            wait(ready === 1);
            #1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        reg [9:0] captured_frame;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmitting 0x00 (All zeros data bits)", test_num);
            reset_dut();

            data_in = 8'h00;
            @(posedge clk) #1 start = 1;
            @(posedge clk) #1 start = 0;

            for (i = 0; i < 10; i = i + 1) begin
                captured_frame[i] = tx;
                @(posedge clk);
            end

            wait(ready === 1);
            #1;


            if (captured_frame === 10'b1000000000) #1;
 check_outputs(1, 1);
            else #1;
 check_outputs(1, 0);
        end
        endtask

    task testcase004;

        reg [9:0] captured_frame;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmitting 0xFF (All ones data bits)", test_num);
            reset_dut();

            data_in = 8'hFF;
            @(posedge clk) #1 start = 1;
            @(posedge clk) #1 start = 0;

            for (i = 0; i < 10; i = i + 1) begin
                captured_frame[i] = tx;
                @(posedge clk);
            end

            wait(ready === 1);
            #1;


            if (captured_frame === 10'b1111111110) #1;
 check_outputs(1, 1);
            else #1;
 check_outputs(1, 0);
        end
        endtask

    task testcase005;

        reg [9:0] captured_frame;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmitting 0x3C (Nibble pattern)", test_num);
            reset_dut();

            data_in = 8'h3C;
            @(posedge clk) #1 start = 1;
            @(posedge clk) #1 start = 0;

            for (i = 0; i < 10; i = i + 1) begin
                captured_frame[i] = tx;
                @(posedge clk);
            end

            wait(ready === 1);
            #1;



            if (captured_frame === 10'b1001111000) #1;
 check_outputs(1, 1);
            else #1;
 check_outputs(1, 0);
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
        input expected_ready;
        input expected_tx;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, tx=%b",
                         ready, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, tx=%b",
                         expected_ready, expected_tx);
                $display("  Got:      ready=%b, tx=%b",
                         ready, tx);
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
        $dumpvars(0,clk, data_in, start, ready, tx);
    end

endmodule
