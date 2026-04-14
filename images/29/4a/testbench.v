`timescale 1ns/1ps

module MinHeap_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg insert;
    reg remove_min;
    reg reset;
    wire [31:0] min_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MinHeap dut (
        .clk(clk),
        .data_in(data_in),
        .insert(insert),
        .remove_min(remove_min),
        .reset(reset),
        .min_out(min_out),
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
            insert = 0;
            remove_min = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task insert_val;

        input [31:0] val;
        begin
            @(posedge clk);
            #1;
            data_in = val;
            insert = 1;
            @(posedge clk);
            #1;
            insert = 0;
            data_in = 0;
            repeat(10) @(posedge clk);
        end
        endtask

    task remove_val;

        begin
            @(posedge clk);
            #1;
            remove_min = 1;
            @(posedge clk);
            #1;
            remove_min = 0;
            repeat(10) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            insert_val(32'd50);
            insert_val(32'd10);
            insert_val(32'd30);
            #1;

            check_outputs(32'd10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            insert_val(32'd100);
            insert_val(32'd20);
            insert_val(32'd150);
            remove_val();
            #1;

            check_outputs(32'd100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            insert_val(32'd10);
            insert_val(32'd5);
            insert_val(32'd20);
            insert_val(32'd1);
            remove_val();
            remove_val();
            #1;

            check_outputs(32'd10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            #1;


            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            insert_val(32'd15);
            insert_val(32'd15);
            insert_val(32'd5);
            remove_val();
            #1;

            check_outputs(32'd15, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            insert_val(32'd40);
            insert_val(32'd30);
            insert_val(32'd20);
            insert_val(32'd10);
            #1;

            check_outputs(32'd10, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MinHeap Testbench");
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
        input [31:0] expected_min_out;
        input expected_valid_out;
        begin
            if (expected_min_out === (expected_min_out ^ min_out ^ expected_min_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: min_out=%h, valid_out=%b",
                         min_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min_out=%h, valid_out=%b",
                         expected_min_out, expected_valid_out);
                $display("  Got:      min_out=%h, valid_out=%b",
                         min_out, valid_out);
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
        $dumpvars(0,clk, data_in, insert, remove_min, reset, min_out, valid_out);
    end

endmodule
