`timescale 1ns/1ps

module cache_replacement_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] policy_select;
    reg request;
    reg reset;
    wire [3:0] replaced_line;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache_replacement dut (
        .clk(clk),
        .policy_select(policy_select),
        .request(request),
        .reset(reset),
        .replaced_line(replaced_line)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            request = 0;
            policy_select = 2'b00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            policy_select = 2'b01;
            request = 1;
            @(posedge clk);
            request = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            reset_dut();
            policy_select = 2'b01;
            for (i = 0; i < 4; i = i + 1) begin
                request = 1;
                @(posedge clk);
                request = 0;
                @(posedge clk);
            end
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            policy_select = 2'b00;
            request = 1;
            @(posedge clk);
            request = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            policy_select = 2'b00;
            for (i = 0; i < 10; i = i + 1) begin
                request = 1;
                @(posedge clk);
                request = 0;
                @(posedge clk);
            end
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            policy_select = 2'b01;
            for (i = 0; i < 17; i = i + 1) begin
                request = 1;
                @(posedge clk);
                request = 0;
                @(posedge clk);
            end
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            policy_select = 2'b01;

            repeat(5) begin
                request = 1; @(posedge clk); request = 0; @(posedge clk);
            end
            reset_dut();
            request = 1;
            @(posedge clk);
            request = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cache_replacement Testbench");
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
        input [3:0] expected_replaced_line;
        begin
            if (expected_replaced_line === (expected_replaced_line ^ replaced_line ^ expected_replaced_line)) begin
                $display("PASS");
                $display("  Outputs: replaced_line=%h",
                         replaced_line);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: replaced_line=%h",
                         expected_replaced_line);
                $display("  Got:      replaced_line=%h",
                         replaced_line);
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
        $dumpvars(0,clk, policy_select, request, reset, replaced_line);
    end

endmodule
