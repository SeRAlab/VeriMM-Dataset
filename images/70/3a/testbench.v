`timescale 1ns/1ps

module bitwise_and_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg rst_n;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_and dut (
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .rst_n(rst_n),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        data_in1 = 8'h00;
        data_in2 = 8'h00;
        @(posedge clk);
        #2 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic AND operation (FF & AA)", test_num);
        reset_dut();
        data_in1 = 8'hFF;
        data_in2 = 8'hAA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero result test (55 & AA)", test_num);
        reset_dut();
        data_in1 = 8'h55;
        data_in2 = 8'hAA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: AND with all zeros", test_num);
        reset_dut();
        data_in1 = 8'hF0;
        data_in2 = 8'h00;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arbitrary pattern (F0 & CC)", test_num);
        reset_dut();
        data_in1 = 8'hF0;
        data_in2 = 8'hCC;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hC0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify reset forces output to zero", test_num);
        reset_dut();
        data_in1 = 8'hFF;
        data_in2 = 8'hFF;
        @(posedge clk);
        #2;

        if (data_out !== 8'hFF) $display("  Initial state error before reset test");


        rst_n = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h00);
        rst_n = 1;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_and Testbench");
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
        $dumpvars(0,clk, data_in1, data_in2, rst_n, data_out);
    end

endmodule
