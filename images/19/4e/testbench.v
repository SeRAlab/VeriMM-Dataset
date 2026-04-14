`timescale 1ns/1ps

module hash_table_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg insert;
    reg [3:0] key;
    reg retrieve;
    reg rst;
    reg [7:0] value;
    wire found;
    wire [7:0] out_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hash_table dut (
        .clk(clk),
        .insert(insert),
        .key(key),
        .retrieve(retrieve),
        .rst(rst),
        .value(value),
        .found(found),
        .out_value(out_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            insert = 0;
            retrieve = 0;
            key = 0;
            value = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Insertion and Retrieval", test_num);
            reset_dut();


            @(posedge clk);
            insert = 1;
            key = 4'h4;
            value = 8'hAA;
            @(posedge clk);
            insert = 0;


            @(posedge clk);
            retrieve = 1;
            key = 4'h4;
            @(posedge clk);
            retrieve = 0;


            #1;



            check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Retrieve non-existent key", test_num);
            reset_dut();


            @(posedge clk);
            insert = 1;
            key = 4'h2;
            value = 8'h55;
            @(posedge clk);
            insert = 0;


            @(posedge clk);
            retrieve = 1;
            key = 4'h7;
            @(posedge clk);
            retrieve = 0;

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Collision Handling (Chaining)", test_num);
            reset_dut();


            @(posedge clk);
            insert = 1;
            key = 4'h1;
            value = 8'h11;
            @(posedge clk);



            insert = 1;
            key = 4'h9;
            value = 8'h99;
            @(posedge clk);
            insert = 0;


            @(posedge clk);
            retrieve = 1;
            key = 4'h9;
            @(posedge clk);
            retrieve = 0;

            #1;


            check_outputs(1'b1, 8'h99);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data persistence after Reset", test_num);
            reset_dut();


            @(posedge clk);
            insert = 1;
            key = 4'hA;
            value = 8'hFF;
            @(posedge clk);
            insert = 0;


            reset_dut();


            @(posedge clk);
            retrieve = 1;
            key = 4'hA;
            @(posedge clk);
            retrieve = 0;

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple unique keys", test_num);
            reset_dut();


            @(posedge clk);
            insert = 1; key = 4'h3; value = 8'h33; @(posedge clk);
            insert = 1; key = 4'h6; value = 8'h66; @(posedge clk);
            insert = 1; key = 4'hB; value = 8'hBB; @(posedge clk);
            insert = 0;


            @(posedge clk);
            retrieve = 1;
            key = 4'h6;
            @(posedge clk);
            retrieve = 0;

            #1;


            check_outputs(1'b1, 8'h66);
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
        input expected_found;
        input [7:0] expected_out_value;
        begin
            if (expected_found === (expected_found ^ found ^ expected_found) &&
                expected_out_value === (expected_out_value ^ out_value ^ expected_out_value)) begin
                $display("PASS");
                $display("  Outputs: found=%b, out_value=%h",
                         found, out_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: found=%b, out_value=%h",
                         expected_found, expected_out_value);
                $display("  Got:      found=%b, out_value=%h",
                         found, out_value);
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
        $dumpvars(0,clk, insert, key, retrieve, rst, value, found, out_value);
    end

endmodule
