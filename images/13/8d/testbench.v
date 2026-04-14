`timescale 1ns/1ps

module pcie_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg rst;
    reg valid;
    wire [31:0] data_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
        .data_out(data_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        valid = 0;
        data_in = 0;
        @(posedge clk);
        #2;
        rst = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Initial State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Single Data Transfer", test_num);
        reset_dut();

        @(negedge clk);
        data_in = 32'hDEADBEEF;
        valid = 1;

        @(posedge clk);
        #2;
        valid = 0;

        #1;


        check_outputs(32'hDEADBEEF, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Valid Low Data Inhibit", test_num);
        reset_dut();

        @(negedge clk);
        data_in = 32'hCAFEBABE;
        valid = 0;

        @(posedge clk);
        #2;


        #1;



        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Consecutive Transfers", test_num);
        reset_dut();


        @(negedge clk);
        data_in = 32'h11111111;
        valid = 1;
        @(posedge clk);


        @(negedge clk);
        data_in = 32'h22222222;
        valid = 1;
        @(posedge clk);
        #2;
        valid = 0;


        #1;



        check_outputs(32'h22222222, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Reset During Operation", test_num);
        reset_dut();


        @(negedge clk);
        data_in = 32'h55555555;
        valid = 1;
        @(posedge clk);
        #2;


        rst = 1;
        @(posedge clk);
        #2;
        rst = 0;


        #1;



        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_controller Testbench");
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
        input [31:0] expected_data_out;
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready=%b",
                         data_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready=%b",
                         expected_data_out, expected_ready);
                $display("  Got:      data_out=%h, ready=%b",
                         data_out, ready);
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
        $dumpvars(0,clk, data_in, rst, valid, data_out, ready);
    end

endmodule
