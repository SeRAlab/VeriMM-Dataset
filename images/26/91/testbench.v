`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    wire done;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .done(done),
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
            data_in = 8'b0;
            repeat(5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Test Case %03d: Transmit 8'h55", test_num);
            reset_dut();

            data_in = 8'h55;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;



            while (!done) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Test Case %03d: Transmit 8'hAA", test_num);
            reset_dut();

            data_in = 8'hAA;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;

            while (!done) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Test Case %03d: Transmit 8'h00", test_num);
            reset_dut();

            data_in = 8'h00;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;

            while (!done) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Test Case %03d: Transmit 8'hFF", test_num);
            reset_dut();

            data_in = 8'hFF;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;

            while (!done) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Test Case %03d: Consecutive Transmissions 0xA5 then 0x5A", test_num);
            reset_dut();


            data_in = 8'hA5;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            while (!done) @(posedge clk);


            @(posedge clk);
            data_in = 8'h5A;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            while (!done) @(posedge clk);
            #1;

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
        input expected_done;
        input expected_tx;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: done=%b, tx=%b",
                         done, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, tx=%b",
                         expected_done, expected_tx);
                $display("  Got:      done=%b, tx=%b",
                         done, tx);
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
        $dumpvars(0,clk, data_in, enable, done, tx);
    end

endmodule
