`timescale 1ns/1ps

module SIPO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg reset;
    reg serial_in;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SIPO_Shift_Register dut (
        .clk(clk),
        .load(load),
        .reset(reset),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            serial_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] data_to_shift;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in 8 bits and load (Pattern: 10101010)", test_num);
            reset_dut();
            data_to_shift = 8'b10101010;


            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = data_to_shift[i];
                @(posedge clk);
            end


            #1 load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(8'b10101010);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] data_to_shift;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in 8 bits and load (Pattern: 11110000)", test_num);
            reset_dut();
            data_to_shift = 8'b11110000;

            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = data_to_shift[i];
                @(posedge clk);
            end

            #1 load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(8'b11110000);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift bits without activating load", test_num);
            reset_dut();


            serial_in = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end


            #1;



            check_outputs(8'b00000000);
        end
        endtask

    task testcase004;

        integer i;
        reg [11:0] data_stream;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 12 bits (Check if only last 8 are kept)", test_num);
            reset_dut();


            data_stream = 12'b1111_10110001;

            for (i = 11; i >= 0; i = i - 1) begin
                serial_in = data_stream[i];
                @(posedge clk);
            end

            #1 load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(8'b10110001);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones", test_num);
            reset_dut();

            serial_in = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end

            #1 load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset and check output clear", test_num);
            reset_dut();


            serial_in = 1;
            for (i = 0; i < 4; i = i + 1) @(posedge clk);


            #1 load = 1;
            @(posedge clk);
            #1 load = 0;


            #1 reset = 1;
            @(posedge clk);
            #1 reset = 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SIPO_Shift_Register Testbench");
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
        input [7:0] expected_parallel_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,clk, load, reset, serial_in, parallel_out);
    end

endmodule
