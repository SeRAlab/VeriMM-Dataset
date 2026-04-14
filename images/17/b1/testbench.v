`timescale 1ns/1ps

module RLE_Encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] data_in;
    reg data_valid;
    reg rst;
    wire [7:0] count_out;
    wire valid_out;
    wire [1:0] value_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE_Encoder dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .count_out(count_out),
        .valid_out(valid_out),
        .value_out(value_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 2'b00;
            data_valid = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: Basic sequence of four 0s", test_num);
            reset_dut();


            data_valid = 1;
            data_in = 2'b00;
            repeat (4) @(posedge clk);


            data_in = 2'b01;
            #1;
            #1;

            check_outputs(8'd4, 1'b1, 2'b00);

            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: Longer sequence of ten 1s", test_num);
            reset_dut();


            data_valid = 1;
            data_in = 2'b01;
            repeat (10) @(posedge clk);


            data_in = 2'b10;
            #1;
            #1;

            check_outputs(8'd10, 1'b1, 2'b01);

            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %0d: Single value run", test_num);
            reset_dut();

            data_valid = 1;
            data_in = 2'b11;
            @(posedge clk);


            data_in = 2'b00;
            #1;
            #1;

            check_outputs(8'd1, 1'b1, 2'b11);

            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %0d: Maximum 8-bit count (255)", test_num);
            reset_dut();

            data_valid = 1;
            data_in = 2'b10;
            repeat (255) @(posedge clk);


            data_in = 2'b11;
            #1;
            #1;

            check_outputs(8'd255, 1'b1, 2'b10);

            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %0d: Alternating sequence", test_num);
            reset_dut();

            data_valid = 1;
            data_in = 2'b01; @(posedge clk);
            data_in = 2'b10; @(posedge clk);
            data_in = 2'b01; #1;


            #1;



            check_outputs(8'd1, 1'b1, 2'b10);

            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %0d: Input stream termination", test_num);
            reset_dut();

            data_valid = 1;
            data_in = 2'b11;
            repeat (5) @(posedge clk);


            data_valid = 0;
            #1;

            #1;


            check_outputs(8'd5, 1'b1, 2'b11);

            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RLE_Encoder Testbench");
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
        input [7:0] expected_count_out;
        input expected_valid_out;
        input [1:0] expected_value_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out) &&
                expected_value_out === (expected_value_out ^ value_out ^ expected_value_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, valid_out=%b, value_out=%h",
                         count_out, valid_out, value_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, valid_out=%b, value_out=%h",
                         expected_count_out, expected_valid_out, expected_value_out);
                $display("  Got:      count_out=%h, valid_out=%b, value_out=%h",
                         count_out, valid_out, value_out);
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
        $dumpvars(0,clk, data_in, data_valid, rst, count_out, valid_out, value_out);
    end

endmodule
