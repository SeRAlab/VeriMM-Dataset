`timescale 1ns/1ps

module hash_table_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg insert_valid;
    reg [31:0] insert_value;
    reg reset;
    reg retrieve_valid;
    reg [31:0] retrieve_value;
    wire insert_success;
    wire [31:0] retrieve_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hash_table dut (
        .clk(clk),
        .insert_valid(insert_valid),
        .insert_value(insert_value),
        .reset(reset),
        .retrieve_valid(retrieve_valid),
        .retrieve_value(retrieve_value),
        .insert_success(insert_success),
        .retrieve_result(retrieve_result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            insert_valid = 0;
            insert_value = 0;
            retrieve_valid = 0;
            retrieve_value = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Insertion and Retrieval", test_num);
            reset_dut();


            @(posedge clk);
            insert_valid = 1;
            insert_value = 32'd42;
            @(posedge clk);
            insert_valid = 0;


            @(posedge clk);
            retrieve_valid = 1;
            retrieve_value = 32'd42;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 32'd42);
            retrieve_valid = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Retrieve Non-existent Value", test_num);
            reset_dut();


            @(posedge clk);
            retrieve_valid = 1;
            retrieve_value = 32'd99;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'hFFFFFFFF);
            retrieve_valid = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Duplicate Value Rejection", test_num);
            reset_dut();


            @(posedge clk);
            insert_valid = 1;
            insert_value = 32'd10;
            @(posedge clk);


            insert_valid = 1;
            insert_value = 32'd10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 32'hFFFFFFFF);
            insert_valid = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Unique Values", test_num);
            reset_dut();


            @(posedge clk);
            insert_valid = 1; insert_value = 32'd1; @(posedge clk);
            insert_valid = 1; insert_value = 32'd2; @(posedge clk);
            insert_valid = 1; insert_value = 32'd3; @(posedge clk);
            insert_valid = 0;


            @(posedge clk);
            retrieve_valid = 1;
            retrieve_value = 32'd2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 32'd2);
            retrieve_valid = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Persistence", test_num);
            reset_dut();


            @(posedge clk);
            insert_valid = 1; insert_value = 32'd55;
            @(posedge clk);
            insert_valid = 0;


            reset_dut();


            @(posedge clk);
            retrieve_valid = 1;
            retrieve_value = 32'd55;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 32'hFFFFFFFF);
            retrieve_valid = 0;
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
        input expected_insert_success;
        input [31:0] expected_retrieve_result;
        begin
            if (expected_insert_success === (expected_insert_success ^ insert_success ^ expected_insert_success) &&
                expected_retrieve_result === (expected_retrieve_result ^ retrieve_result ^ expected_retrieve_result)) begin
                $display("PASS");
                $display("  Outputs: insert_success=%b, retrieve_result=%h",
                         insert_success, retrieve_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: insert_success=%b, retrieve_result=%h",
                         expected_insert_success, expected_retrieve_result);
                $display("  Got:      insert_success=%b, retrieve_result=%h",
                         insert_success, retrieve_result);
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
        $dumpvars(0,clk, insert_valid, insert_value, reset, retrieve_valid, retrieve_value, insert_success, retrieve_result);
    end

endmodule
