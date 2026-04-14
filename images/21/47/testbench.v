`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] index;
    reg reset;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .index(index),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            index = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            index = 3'd0;

            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            index = 3'd1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            index = 3'd3;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            index = 3'd7;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            index = 3'd2;
            repeat(10) @(posedge clk);

            reset_dut();
            index = 3'd5;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'd60);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linked_list_traversal Testbench");
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
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, index, reset, data_out);
    end

endmodule
