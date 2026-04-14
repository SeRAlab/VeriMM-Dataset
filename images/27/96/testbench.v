`timescale 1ns/1ps

module ofdm_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
    wire done;
    wire [15:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .done(done),
        .signal_out(signal_out)
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
            data_in = 8'h00;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Zeros Input", test_num);
            reset_dut();

            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1);



            #1;




            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Ones Input (DC)", test_num);
            reset_dut();

            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);





            #1;






            check_outputs(1'b1, 16'h0100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Single Subcarrier (Index 0)", test_num);
            reset_dut();

            data_in = 8'h01;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);


            #1;



            check_outputs(1'b1, 16'h0020);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Alternating Bits (High Frequency)", test_num);
            reset_dut();

            data_in = 8'hAA;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);


            #1;



            check_outputs(1'b1, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_transmitter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_signal_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, signal_out=%h",
                         done, signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, signal_out=%h",
                         expected_done, expected_signal_out);
                $display("  Got:      done=%b, signal_out=%h",
                         done, signal_out);
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
        $dumpvars(0,clk, data_in, reset, start, done, signal_out);
    end

endmodule
