`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] data_in;
    reg reset;
    reg valid;
    wire bit_out;
    wire [7:0] count_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .bit_out(bit_out),
        .count_out(count_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            data_in = 2'b00;
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
            $display("Test Case %0d: Run of three 0s triggered by a 1", test_num);
            reset_dut();


            repeat(3) begin
                valid = 1; data_in = 2'b00; @(posedge clk); #1;
            end


            valid = 1; data_in = 2'b01; @(posedge clk); #1;


            #1;



            check_outputs(1'b0, 8'd3, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Run of five 1s triggered by a 0", test_num);
            reset_dut();


            repeat(5) begin
                valid = 1; data_in = 2'b01; @(posedge clk); #1;
            end


            valid = 1; data_in = 2'b00; @(posedge clk); #1;


            #1;



            check_outputs(1'b1, 8'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit run (0 then 1)", test_num);
            reset_dut();


            valid = 1; data_in = 2'b00; @(posedge clk); #1;


            valid = 1; data_in = 2'b01; @(posedge clk); #1;


            #1;



            check_outputs(1'b0, 8'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input stream with valid gaps", test_num);
            reset_dut();


            valid = 1; data_in = 2'b00; @(posedge clk); #1;


            valid = 0; data_in = 2'b01; @(posedge clk); #1;
            valid = 0; data_in = 2'b00; @(posedge clk); #1;


            valid = 1; data_in = 2'b00; @(posedge clk); #1;


            valid = 1; data_in = 2'b01; @(posedge clk); #1;


            #1;



            check_outputs(1'b0, 8'd2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple consecutive runs (Checking second run)", test_num);
            reset_dut();


            valid = 1; data_in = 2'b00; @(posedge clk); #1;
            valid = 1; data_in = 2'b00; @(posedge clk); #1;


            valid = 1; data_in = 2'b01; @(posedge clk); #1;
            valid = 1; data_in = 2'b01; @(posedge clk); #1;
            valid = 1; data_in = 2'b01; @(posedge clk); #1;


            valid = 1; data_in = 2'b00; @(posedge clk); #1;


            #1;



            check_outputs(1'b1, 8'd3, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();


            valid = 1; data_in = 2'b01; @(posedge clk); #1;
            valid = 1; data_in = 2'b01; @(posedge clk); #1;


            reset = 1; @(posedge clk); #1;
            reset = 0; @(posedge clk); #1;


            valid = 1; data_in = 2'b00; @(posedge clk); #1;
            valid = 1; data_in = 2'b00; @(posedge clk); #1;
            valid = 1; data_in = 2'b01; @(posedge clk); #1;


            #1;



            check_outputs(1'b0, 8'd2, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_encoder Testbench");
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
        input expected_bit_out;
        input [7:0] expected_count_out;
        input expected_valid_out;
        begin
            if (expected_bit_out === (expected_bit_out ^ bit_out ^ expected_bit_out) &&
                expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: bit_out=%b, count_out=%h, valid_out=%b",
                         bit_out, count_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_out=%b, count_out=%h, valid_out=%b",
                         expected_bit_out, expected_count_out, expected_valid_out);
                $display("  Got:      bit_out=%b, count_out=%h, valid_out=%b",
                         bit_out, count_out, valid_out);
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
        $dumpvars(0,clk, data_in, reset, valid, bit_out, count_out, valid_out);
    end

endmodule
