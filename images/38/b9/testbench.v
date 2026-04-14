`timescale 1ns/1ps

module stack_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop;
    reg push;
    reg reset;
    wire [7:0] data_out;
    wire empty;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stack dut (
        .clk(clk),
        .data_in(data_in),
        .pop(pop),
        .push(push),
        .reset(reset),
        .data_out(data_out),
        .empty(empty)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            push = 0;
            pop = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Check state immediately after reset");
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Push 0xAA and pop it");
            test_num = 2;
            reset_dut();

            push = 1; data_in = 8'hAA; @(posedge clk);
            #1 push = 0; @(posedge clk);

            pop = 1; @(posedge clk);
            #1 pop = 0; @(posedge clk);
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Push 0x11 then 0x22, pop once");
            test_num = 3;
            reset_dut();

            push = 1; data_in = 8'h11; @(posedge clk);

            #1 data_in = 8'h22; @(posedge clk);
            #1 push = 0; @(posedge clk);

            pop = 1; @(posedge clk);
            #1 pop = 0; @(posedge clk);
            #1;

            check_outputs(8'h22, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Push 0x11 then 0x22, pop twice");
            test_num = 4;
            reset_dut();

            push = 1; data_in = 8'h11; @(posedge clk);
            #1 data_in = 8'h22; @(posedge clk);
            #1 push = 0; @(posedge clk);

            pop = 1; @(posedge clk);
            @(posedge clk);
            #1 pop = 0; @(posedge clk);
            #1;

            check_outputs(8'h11, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Fill stack to depth 8 and check not empty");
            test_num = 5;
            reset_dut();
            push = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            #1 push = 0; @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Fill stack to 8 items then pop all");
            test_num = 6;
            reset_dut();

            push = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            #1 push = 0;

            pop = 1;
            repeat(8) @(posedge clk);
            #1 pop = 0; @(posedge clk);
            #1;

            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Interleaved push and pop");
            test_num = 7;
            reset_dut();

            push = 1; data_in = 8'h55; @(posedge clk);
            #1 data_in = 8'h66; @(posedge clk);

            #1 push = 0; pop = 1; @(posedge clk);

            #1 pop = 0; push = 1; data_in = 8'h77; @(posedge clk);

            #1 push = 0; pop = 1; @(posedge clk);
            #1 pop = 0; @(posedge clk);
            #1;

            check_outputs(8'h77, 1'b0);
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
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b",
                         data_out, empty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b",
                         expected_data_out, expected_empty);
                $display("  Got:      data_out=%h, empty=%b",
                         data_out, empty);
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
        $dumpvars(0,clk, data_in, pop, push, reset, data_out, empty);
    end

endmodule
