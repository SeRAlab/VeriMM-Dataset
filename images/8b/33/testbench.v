`timescale 1ns/1ps

module high_bit_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
    wire done;
    wire [3:0] high_bit_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    high_bit_counter dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .done(done),
        .high_bit_count(high_bit_count)
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
            data_in = 8'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Data In = 8'b00000000", test_num);
            data_in = 8'b00000000;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            while (!done) @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Data In = 8'b11111111", test_num);
            data_in = 8'b11111111;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Data In = 8'b10101010", test_num);
            data_in = 8'b10101010;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Data In = 8'b00000001", test_num);
            data_in = 8'b00000001;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Data In = 8'b11110000", test_num);
            data_in = 8'b11110000;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Data In = 8'b11011011", test_num);
            data_in = 8'b11011011;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 4'd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("high_bit_counter Testbench");
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
        input expected_done;
        input [3:0] expected_high_bit_count;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_high_bit_count === (expected_high_bit_count ^ high_bit_count ^ expected_high_bit_count)) begin
                $display("PASS");
                $display("  Outputs: done=%b, high_bit_count=%h",
                         done, high_bit_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, high_bit_count=%h",
                         expected_done, expected_high_bit_count);
                $display("  Got:      done=%b, high_bit_count=%h",
                         done, high_bit_count);
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
        $dumpvars(0,clk, data_in, reset, start, done, high_bit_count);
    end

endmodule
