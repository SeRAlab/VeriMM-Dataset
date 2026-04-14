`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    wire [7:0] data;
    wire flag_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .data(data),
        .flag_complete(flag_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 1;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] test_val;
        begin
            reset_dut();
            test_num = test_num + 1;
            test_val = 8'h55;
            $display("Testcase %0d: Sending data %h", test_num, test_val);


            in = 0;
            @(posedge clk);


            for (i = 0; i < 8; i = i + 1) begin
                in = test_val[i];
                @(posedge clk);
            end


            in = 1;
            #1;
            #1;

            check_outputs(test_val, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] test_val;
        begin
            reset_dut();
            test_num = test_num + 1;
            test_val = 8'hAA;
            $display("Testcase %0d: Sending data %h", test_num, test_val);


            in = 0;
            @(posedge clk);


            for (i = 0; i < 8; i = i + 1) begin
                in = test_val[i];
                @(posedge clk);
            end

            in = 1;
            #1;
            #1;

            check_outputs(test_val, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] test_val;
        begin
            reset_dut();
            test_num = test_num + 1;
            test_val = 8'hFF;
            $display("Testcase %0d: Sending data %h", test_num, test_val);


            in = 0;
            @(posedge clk);


            for (i = 0; i < 8; i = i + 1) begin
                in = test_val[i];
                @(posedge clk);
            end

            in = 1;
            #1;
            #1;

            check_outputs(test_val, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] test_val;
        begin
            reset_dut();
            test_num = test_num + 1;
            test_val = 8'h00;
            $display("Testcase %0d: Sending data %h", test_num, test_val);


            in = 0;
            @(posedge clk);


            for (i = 0; i < 8; i = i + 1) begin
                in = test_val[i];
                @(posedge clk);
            end

            in = 1;
            #1;
            #1;

            check_outputs(test_val, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] test_val;
        begin
            reset_dut();
            test_num = test_num + 1;
            test_val = 8'hC3;
            $display("Testcase %0d: Sending data %h", test_num, test_val);


            in = 0;
            @(posedge clk);


            for (i = 0; i < 8; i = i + 1) begin
                in = test_val[i];
                @(posedge clk);
            end

            in = 1;
            #1;
            #1;

            check_outputs(test_val, 1'b1);
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
        input [7:0] expected_data;
        input expected_flag_complete;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_flag_complete === (expected_flag_complete ^ flag_complete ^ expected_flag_complete)) begin
                $display("PASS");
                $display("  Outputs: data=%h, flag_complete=%b",
                         data, flag_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, flag_complete=%b",
                         expected_data, expected_flag_complete);
                $display("  Got:      data=%h, flag_complete=%b",
                         data, flag_complete);
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
        $dumpvars(0,clk, in, data, flag_complete);
    end

endmodule
