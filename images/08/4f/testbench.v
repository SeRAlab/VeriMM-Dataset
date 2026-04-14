`timescale 1ns/1ps

module stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] ctrl;
    reg [7:0] data_in;
    reg rst_n;
    wire [7:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stack dut (
        .clk(clk),
        .ctrl(ctrl),
        .data_in(data_in),
        .rst_n(rst_n),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            ctrl = 3'b000;
            data_in = 8'h00;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial State after Reset");
            reset_dut();

            #1;


            check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Push 0x55 and Peek");
            reset_dut();

            ctrl = 3'b000; data_in = 8'h55; @(posedge clk);

            #1 ctrl = 3'b010; @(posedge clk);
            #1 #1;
 check_outputs(8'h55, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Push 8 elements to fill the stack");
            reset_dut();
            for (i = 1; i <= 8; i = i + 1) begin
                ctrl = 3'b000; data_in = i; @(posedge clk);
                #1;
            end

            #1;


            check_outputs(8'h08, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Fill stack and then Pop one element");
            reset_dut();
            for (i = 1; i <= 8; i = i + 1) begin
                ctrl = 3'b000; data_in = i; @(posedge clk);
                #1;
            end

            ctrl = 3'b001; @(posedge clk);
            #1 #1;
 check_outputs(8'h08, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Pop from empty stack");
            reset_dut();

            ctrl = 3'b001; @(posedge clk);
            #1 #1;
 check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Push 9 elements to a size-8 stack");
            reset_dut();
            for (i = 1; i <= 8; i = i + 1) begin
                ctrl = 3'b000; data_in = i; @(posedge clk);
                #1;
            end

            ctrl = 3'b000; data_in = 8'hFF; @(posedge clk);
            #1;

            ctrl = 3'b010; @(posedge clk);
            #1 #1;
 check_outputs(8'h08, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Complex Push/Pop LIFO sequence");
            reset_dut();

            ctrl = 3'b000; data_in = 8'hAA; @(posedge clk); #1;
            ctrl = 3'b000; data_in = 8'hBB; @(posedge clk); #1;
            ctrl = 3'b001; @(posedge clk); #1;
            ctrl = 3'b000; data_in = 8'hCC; @(posedge clk); #1;
            ctrl = 3'b001; @(posedge clk); #1;
            ctrl = 3'b001; @(posedge clk); #1;

            #1;


            check_outputs(8'hAA, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stack Testbench");
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
        input [7:0] expected_data_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clk, ctrl, data_in, rst_n, data_out, empty, full);
    end

endmodule
