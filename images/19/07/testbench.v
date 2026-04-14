`timescale 1ns/1ps

module LinkedList_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg insert;
    reg reset;
    wire [7:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LinkedList dut (
        .clk(clk),
        .data_in(data_in),
        .insert(insert),
        .reset(reset),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            insert = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTest Case 001: Insert 1 element (8'hAA)");
            reset_dut();


            data_in = 8'hAA;
            insert = 1;
            @(posedge clk);
            insert = 0;



            wait(valid == 1);
            #1;

            check_outputs(8'hAA, 1);
            @(posedge clk);
            #1;

            check_outputs(8'h00, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: Insert 3 elements (11, 22, 33)");
            reset_dut();


            data_in = 8'h11;
            insert = 1;
            @(posedge clk);

            data_in = 8'h22;
            @(posedge clk);

            data_in = 8'h33;
            @(posedge clk);
            insert = 0;


            wait(valid == 1);
            #1;

            check_outputs(8'h11, 1); @(posedge clk);
            #1;

            check_outputs(8'h22, 1); @(posedge clk);
            #1;

            check_outputs(8'h33, 1); @(posedge clk);
            #1;

            check_outputs(8'h00, 0);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] expected_vals [0:4];
        begin
            $display("\nTest Case 003: Maximum Capacity (5 elements)");
            reset_dut();

            expected_vals[0] = 8'h01; expected_vals[1] = 8'h02;
            expected_vals[2] = 8'h03; expected_vals[3] = 8'h04;
            expected_vals[4] = 8'h05;


            insert = 1;
            for (i = 0; i < 5; i = i + 1) begin
                data_in = expected_vals[i];
                @(posedge clk);
            end
            insert = 0;


            wait(valid == 1);
            for (i = 0; i < 5; i = i + 1) begin
                #1;

                check_outputs(expected_vals[i], 1);
                @(posedge clk);
            end
            #1;

            check_outputs(8'h00, 0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("\nTest Case 004: Overflow (Insert 6 elements, limit is 5)");
            reset_dut();

            insert = 1;
            for (i = 1; i <= 6; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            insert = 0;


            wait(valid == 1);
            for (i = 1; i <= 5; i = i + 1) begin
                #1;

                check_outputs(i, 1);
                @(posedge clk);
            end

            if (valid && data_out == 8'h06) begin
                $display("FAIL: List allowed 6th node.");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: List correctly limited to 5 nodes.");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Empty List Check");
            reset_dut();


            repeat(5) @(posedge clk);


            if (valid == 0) begin
                $display("PASS: Valid remains low for empty list.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Valid high for empty list.");
                fail_count = fail_count + 1;
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
        $display("LinkedList Testbench");
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
        input [7:0] expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, data_in, insert, reset, data_out, valid);
    end

endmodule
