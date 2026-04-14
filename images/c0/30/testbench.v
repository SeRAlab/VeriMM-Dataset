`timescale 1ns/1ps

module oc_fifo_basic_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg give;
    reg [7:0] give_di;
    reg rst_i;
    reg take;
    wire have;
    wire need;
    wire [7:0] take_do;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    oc_fifo_basic dut (
        .clk_i(clk_i),
        .give(give),
        .give_di(give_di),
        .rst_i(rst_i),
        .take(take),
        .have(have),
        .need(need),
        .take_do(take_do)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            give = 0;
            take = 0;
            give_di = 0;
            repeat (2) @(posedge clk_i);
            #1 rst_i = 0;
            @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Initial state after reset");
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b1, 8'hxx);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Single write operation");
            reset_dut();
            @(posedge clk_i);
            #1;
            give = 1;
            give_di = 8'hA5;
            @(posedge clk_i);
            #1;
            give = 0;

            #1;


            check_outputs(1'b1, 1'b1, 8'hA5);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Test Case 003: Filling FIFO to full (Depth 16)");
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk_i);
                #1;
                give = 1;
                give_di = i[7:0];
            end
            @(posedge clk_i);
            #1;
            give = 0;

            #1;


            check_outputs(1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Test Case 004: Filling and draining FIFO");
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk_i);
                #1;
                give = 1;
                give_di = i[7:0] + 8'h10;
            end
            @(posedge clk_i);
            #1;
            give = 0;

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk_i);
                #1;
                take = 1;
            end
            @(posedge clk_i);
            #1;
            take = 0;

            #1;


            check_outputs(1'b0, 1'b1, 8'hxx);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Simultaneous read and write");
            reset_dut();

            @(posedge clk_i);
            #1;
            give = 1;
            give_di = 8'hAA;
            @(posedge clk_i);
            #1;

            give = 1;
            give_di = 8'hBB;
            take = 1;
            @(posedge clk_i);
            #1;
            give = 0;
            take = 0;

            #1;


            check_outputs(1'b1, 1'b1, 8'hBB);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Test Case 006: FIFO wrap-around pointer test");
            reset_dut();

            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk_i);
                #1;
                give = 1;
                give_di = i[7:0];
            end
            @(posedge clk_i);
            #1;
            give = 0;

            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk_i);
                #1;
                take = 1;
            end
            @(posedge clk_i);
            #1;
            take = 0;

            for (i = 10; i < 20; i = i + 1) begin
                @(posedge clk_i);
                #1;
                if (need) begin
                    give = 1;
                    give_di = i[7:0];
                end else give = 0;
            end
            @(posedge clk_i);
            #1;
            give = 0;

            #1;


            check_outputs(1'b1, 1'b0, 8'h05);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("oc_fifo_basic Testbench");
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
        input expected_have;
        input expected_need;
        input [7:0] expected_take_do;
        begin
            if (expected_have === (expected_have ^ have ^ expected_have) &&
                expected_need === (expected_need ^ need ^ expected_need) &&
                expected_take_do === (expected_take_do ^ take_do ^ expected_take_do)) begin
                $display("PASS");
                $display("  Outputs: have=%b, need=%b, take_do=%h",
                         have, need, take_do);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: have=%b, need=%b, take_do=%h",
                         expected_have, expected_need, expected_take_do);
                $display("  Got:      have=%b, need=%b, take_do=%h",
                         have, need, take_do);
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
        $dumpvars(0,clk_i, give, give_di, rst_i, take, have, need, take_do);
    end

endmodule
