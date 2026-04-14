`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    wire [1:0] qpsk_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .qpsk_out(qpsk_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 4'b0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: data_in = 4'b0000", test_num);
            reset_dut();
            data_in = 4'b0000;


            wait(ready === 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: data_in = 4'b1111", test_num);
            reset_dut();
            data_in = 4'b1111;

            wait(ready === 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: data_in = 4'b1010", test_num);
            reset_dut();
            data_in = 4'b1010;

            wait(ready === 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: data_in = 4'b0101", test_num);
            reset_dut();
            data_in = 4'b0101;

            wait(ready === 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: data_in = 4'b0011", test_num);
            reset_dut();
            data_in = 4'b0011;

            wait(ready === 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: data_in = 4'b1100", test_num);
            reset_dut();
            data_in = 4'b1100;

            wait(ready === 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: data_in = 4'b0110", test_num);
            reset_dut();
            data_in = 4'b0110;

            wait(ready === 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: data_in = 4'b1001", test_num);
            reset_dut();
            data_in = 4'b1001;

            wait(ready === 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_modulator Testbench");
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
        input [1:0] expected_qpsk_out;
        input expected_ready;
        begin
            if (expected_qpsk_out === (expected_qpsk_out ^ qpsk_out ^ expected_qpsk_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: qpsk_out=%h, ready=%b",
                         qpsk_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qpsk_out=%h, ready=%b",
                         expected_qpsk_out, expected_ready);
                $display("  Got:      qpsk_out=%h, ready=%b",
                         qpsk_out, ready);
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
        $dumpvars(0,clk, data_in, reset, qpsk_out, ready);
    end

endmodule
