`timescale 1ns/1ps

module binary_max_heap_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg delete_max;
    reg [7:0] insert_data;
    reg insert_valid;
    reg rst;
    wire [7:0] max_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_max_heap dut (
        .clk(clk),
        .delete_max(delete_max),
        .insert_data(insert_data),
        .insert_valid(insert_valid),
        .rst(rst),
        .max_out(max_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            delete_max = 0;
            insert_valid = 0;
            insert_data = 0;
            repeat (5) @(posedge clk);
            rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task insert_val;

        input [7:0] val;
        begin
            @(posedge clk);
            insert_data = val;
            insert_valid = 1;
            @(posedge clk);
            insert_valid = 0;
            insert_data = 0;

            repeat (20) @(posedge clk);
        end
        endtask

    task delete_val;

        begin
            @(posedge clk);
            delete_max = 1;
            @(posedge clk);
            delete_max = 0;
            repeat (20) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single insertion", test_num);
            reset_dut();
            insert_val(8'hA5);
            #1;

            check_outputs(8'hA5, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiple insertions (Increasing)", test_num);
            reset_dut();
            insert_val(8'h10);
            insert_val(8'h20);
            insert_val(8'h30);
            #1;

            check_outputs(8'h30, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Multiple insertions (Decreasing)", test_num);
            reset_dut();
            insert_val(8'hFF);
            insert_val(8'hAA);
            insert_val(8'h55);
            #1;

            check_outputs(8'hFF, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Delete Max", test_num);
            reset_dut();
            insert_val(8'h10);
            insert_val(8'h50);
            insert_val(8'h20);

            delete_val();

            #1;


            check_outputs(8'h20, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequence of Deletions", test_num);
            reset_dut();
            insert_val(8'h05);
            insert_val(8'h15);
            insert_val(8'h10);
            insert_val(8'h25);

            delete_val();
            #1;

            check_outputs(8'h15, 1);

            delete_val();
            #1;

            check_outputs(8'h10, 1);

            delete_val();
            #1;

            check_outputs(8'h05, 1);

            delete_val();
            #1;

            check_outputs(8'h00, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Duplicate values", test_num);
            reset_dut();
            insert_val(8'h44);
            insert_val(8'h44);
            insert_val(8'h11);
            #1;

            check_outputs(8'h44, 1);

            delete_val();
            #1;

            check_outputs(8'h44, 1);

            delete_val();
            #1;

            check_outputs(8'h11, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_max_heap Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_max_out;
        input expected_valid_out;
        begin
            if (expected_max_out === (expected_max_out ^ max_out ^ expected_max_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: max_out=%h, valid_out=%b",
                         max_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_out=%h, valid_out=%b",
                         expected_max_out, expected_valid_out);
                $display("  Got:      max_out=%h, valid_out=%b",
                         max_out, valid_out);
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
        $dumpvars(0,clk, delete_max, insert_data, insert_valid, rst, max_out, valid_out);
    end

endmodule
