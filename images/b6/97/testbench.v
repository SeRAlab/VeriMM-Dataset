`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load_data;
    reg rst;
    wire q;
    wire [7:0] q_parallel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load_data(load_data),
        .rst(rst),
        .q(q),
        .q_parallel(q_parallel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        load_data = 0;
        data_in = 8'h00;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Parallel Load (0x55)", test_num);
        reset_dut();
        data_in = 8'h55;
        load_data = 1;
        @(posedge clk);
        #1;
        load_data = 0;

        #1;


        check_outputs(1'b1, 8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Parallel Load (0xAA)", test_num);
        reset_dut();
        data_in = 8'hAA;
        load_data = 1;
        @(posedge clk);
        #1;
        load_data = 0;

        #1;


        check_outputs(1'b0, 8'hAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Circular Left Shift (1 step)", test_num);
        reset_dut();
        data_in = 8'h81;
        load_data = 1;
        @(posedge clk);
        #1;
        load_data = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 8'h03);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Circular Left Shift (4 steps)", test_num);
        reset_dut();
        data_in = 8'hF0;
        load_data = 1;
        @(posedge clk);
        #1;
        load_data = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 8'h0F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Circular Left Shift (Full Circle)", test_num);
        reset_dut();
        data_in = 8'h12;
        load_data = 1;
        @(posedge clk);
        #1;
        load_data = 0;
        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'h12);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Circular Shift All Ones", test_num);
        reset_dut();
        data_in = 8'hFF;
        load_data = 1;
        @(posedge clk);
        #1;
        load_data = 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-operation Load", test_num);
        reset_dut();
        data_in = 8'h01;
        load_data = 1;
        @(posedge clk);
        #1;
        load_data = 0;
        @(posedge clk);
        #1;
        data_in = 8'h44;
        load_data = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'h44);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_q;
        input [7:0] expected_q_parallel;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_parallel === (expected_q_parallel ^ q_parallel ^ expected_q_parallel)) begin
                $display("PASS");
                $display("  Outputs: q=%b, q_parallel=%h",
                         q, q_parallel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, q_parallel=%h",
                         expected_q, expected_q_parallel);
                $display("  Got:      q=%b, q_parallel=%h",
                         q, q_parallel);
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
        $dumpvars(0,clk, data_in, load_data, rst, q, q_parallel);
    end

endmodule
