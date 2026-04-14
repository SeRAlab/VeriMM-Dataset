`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [254:0] add_in_0;
    reg [254:0] add_in_1;
    reg clk;
    reg rst;
    wire [255:0] add_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add_in_0(add_in_0),
        .add_in_1(add_in_1),
        .clk(clk),
        .rst(rst),
        .add_out(add_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            add_in_0 = 0;
            add_in_1 = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero addition after reset", test_num);
            reset_dut();
            add_in_0 = 0;
            add_in_1 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(256'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic addition (123 + 456)", test_num);
            reset_dut();
            add_in_0 = 255'd123;
            add_in_1 = 255'd456;
            @(posedge clk);
            #2;
            #1;

            check_outputs(256'd579);
        end
        endtask

    task testcase003;

        reg [254:0] max_255;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary - Max 255-bit + 1", test_num);
            reset_dut();
            max_255 = {255{1'b1}};
            add_in_0 = max_255;
            add_in_1 = 255'd1;
            @(posedge clk);
            #2;

            #1;


            check_outputs({1'b1, {255{1'b0}}});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large hex values addition", test_num);
            reset_dut();
            add_in_0 = {128'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA, 127'h5555_5555_5555_5555_5555_5555_5555_555};
            add_in_1 = {128'h1111_1111_1111_1111_1111_1111_1111_1111, 127'h2222_2222_2222_2222_2222_2222_2222_222};
            @(posedge clk);
            #2;
            #1;

            check_outputs(add_in_0 + add_in_1);
        end
        endtask

    task testcase005;

        reg [254:0] max_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max 255-bit + Max 255-bit", test_num);
            reset_dut();
            max_val = {255{1'b1}};
            add_in_0 = max_val;
            add_in_1 = max_val;
            @(posedge clk);
            #2;

            #1;


            check_outputs({255'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 1'b0} << 1);

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
        input [255:0] expected_add_out;
        begin
            if (expected_add_out === (expected_add_out ^ add_out ^ expected_add_out)) begin
                $display("PASS");
                $display("  Outputs: add_out=%h",
                         add_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_out=%h",
                         expected_add_out);
                $display("  Got:      add_out=%h",
                         add_out);
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
        $dumpvars(0,add_in_0, add_in_1, clk, rst, add_out);
    end

endmodule
