`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg c;
    reg clk;
    wire [2:0] encoded_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .encoded_output(encoded_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a <= 4'b0000;
        b <= 4'b0000;
        c <= 1'b0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: a == b, Bit 0 active", test_num);
        a <= 4'b0001;
        b <= 4'b0001;
        c <= 1'b0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: a == b, Bit 3 active", test_num);
        a <= 4'b1000;
        b <= 4'b1000;
        c <= 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: a != b, c=0 (Selecting 'a')", test_num);
        a <= 4'b0010;
        b <= 4'b1111;
        c <= 1'b0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: a != b, c=1 (Selecting 'b')", test_num);
        a <= 4'b1111;
        b <= 4'b0100;
        c <= 1'b1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(3'd6);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: a != b, c=1, b bit 0 active", test_num);
        a <= 4'b0000;
        b <= 4'b0001;
        c <= 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Priority within 'a' (Multiple bits set)", test_num);
        a <= 4'b1011;
        b <= 4'b0000;
        c <= 1'b0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Priority within 'b' (Multiple bits set)", test_num);
        a <= 4'b0000;
        b <= 4'b0110;
        c <= 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: All bits active, c=0", test_num);
        a <= 4'b1111;
        b <= 4'b1111;
        c <= 1'b0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd3);
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
        input [2:0] expected_encoded_output;
        begin
            if (expected_encoded_output === (expected_encoded_output ^ encoded_output ^ expected_encoded_output)) begin
                $display("PASS");
                $display("  Outputs: encoded_output=%h",
                         encoded_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_output=%h",
                         expected_encoded_output);
                $display("  Got:      encoded_output=%h",
                         encoded_output);
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
        $dumpvars(0,a, b, c, clk, encoded_output);
    end

endmodule
