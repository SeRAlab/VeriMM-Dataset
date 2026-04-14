`timescale 1ns/1ps

module hash_table_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg insert;
    reg [7:0] key_in;
    reg reset;
    reg retrieve;
    reg [7:0] value_in;
    wire valid;
    wire [7:0] value_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hash_table dut (
        .clk(clk),
        .insert(insert),
        .key_in(key_in),
        .reset(reset),
        .retrieve(retrieve),
        .value_in(value_in),
        .valid(valid),
        .value_out(value_out)
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
            retrieve = 0;
            key_in = 0;
            value_in = 0;
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
            $display("Testcase %0d: Basic Insertion and Retrieval", test_num);
            reset_dut();


            @(posedge clk);
            insert = 1;
            key_in = 8'h05;
            value_in = 8'hAA;
            @(posedge clk);
            insert = 0;


            @(posedge clk);
            retrieve = 1;
            key_in = 8'h05;
            @(posedge clk);
            retrieve = 0;

            #1;
            #1;

            check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Collision Handling (Overwrite)", test_num);
            reset_dut();


            @(posedge clk);
            insert = 1;
            key_in = 8'h05;
            value_in = 8'hAA;
            @(posedge clk);


            key_in = 8'h15;
            value_in = 8'hBB;
            @(posedge clk);
            insert = 0;


            @(posedge clk);
            retrieve = 1;
            key_in = 8'h05;
            @(posedge clk);
            retrieve = 0;

            #1;
            #1;

            check_outputs(1'b1, 8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Retrieval of an empty slot", test_num);
            reset_dut();


            @(posedge clk);
            retrieve = 1;
            key_in = 8'h0A;
            @(posedge clk);
            retrieve = 0;

            #1;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Key-Value Pairs (Max Capacity)", test_num);
            reset_dut();


            @(posedge clk);
            insert = 1;
            key_in = 8'h01; value_in = 8'h11; @(posedge clk);
            key_in = 8'h02; value_in = 8'h22; @(posedge clk);
            key_in = 8'h03; value_in = 8'h33; @(posedge clk);
            key_in = 8'h04; value_in = 8'h44; @(posedge clk);
            key_in = 8'h0F; value_in = 8'hFF; @(posedge clk);
            insert = 0;


            @(posedge clk);
            retrieve = 1;
            key_in = 8'h0F;
            @(posedge clk);
            retrieve = 0;

            #1;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset behavior", test_num);
            reset_dut();


            @(posedge clk);
            insert = 1;
            key_in = 8'h08;
            value_in = 8'h88;
            @(posedge clk);
            insert = 0;


            reset_dut();


            @(posedge clk);
            retrieve = 1;
            key_in = 8'h08;
            @(posedge clk);
            retrieve = 0;

            #1;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hash_table Testbench");
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
        input expected_valid;
        input [7:0] expected_value_out;
        begin
            if (expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_value_out === (expected_value_out ^ value_out ^ expected_value_out)) begin
                $display("PASS");
                $display("  Outputs: valid=%b, value_out=%h",
                         valid, value_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b, value_out=%h",
                         expected_valid, expected_value_out);
                $display("  Got:      valid=%b, value_out=%h",
                         valid, value_out);
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
        $dumpvars(0,clk, insert, key_in, reset, retrieve, value_in, valid, value_out);
    end

endmodule
