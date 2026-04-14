`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_en;
    reg [5:0] data_in1;
    reg [5:0] data_in2;
    reg sreset;
    wire data_out1;
    wire data_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_en(clk_en),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .sreset(sreset),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        sreset = 1;
        clk_en = 0;
        data_in1 = 0;
        data_in2 = 0;
        @(posedge clk);
        #1;
        sreset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Synchronous Reset Verification", test_num);
        reset_dut();


        #1;



        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: clk_en=1, reduction AND = 1", test_num);
        reset_dut();

        @(negedge clk);
        clk_en = 1;
        data_in1 = 6'b111111;
        data_in2 = 6'b111111;

        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: clk_en=1, reduction AND = 0", test_num);
        reset_dut();

        @(negedge clk);
        clk_en = 1;
        data_in1 = 6'b110111;
        data_in2 = 6'b011111;

        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: clk_en=0, Hold value", test_num);
        reset_dut();


        @(negedge clk);
        clk_en = 1;
        data_in1 = 6'b111111;
        data_in2 = 6'b111111;
        @(posedge clk);
        #1;


        @(negedge clk);
        clk_en = 0;
        data_in1 = 6'b000000;
        data_in2 = 6'b000000;
        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset priority over clk_en", test_num);
        reset_dut();

        @(negedge clk);
        sreset = 1;
        clk_en = 1;
        data_in1 = 6'b111111;
        data_in2 = 6'b111111;

        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mixed Data Inputs", test_num);
        reset_dut();

        @(negedge clk);
        clk_en = 1;
        data_in1 = 6'b111111;
        data_in2 = 6'b111011;

        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_data_out1;
        input expected_data_out2;
        begin
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%b, data_out2=%b",
                         data_out1, data_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%b, data_out2=%b",
                         expected_data_out1, expected_data_out2);
                $display("  Got:      data_out1=%b, data_out2=%b",
                         data_out1, data_out2);
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
        $dumpvars(0,clk, clk_en, data_in1, data_in2, sreset, data_out1, data_out2);
    end

endmodule
