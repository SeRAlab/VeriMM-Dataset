`timescale 1ns/1ps

module or_pipe_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_en;
    reg [31:0] or_a;
    reg [31:0] or_b;
    reg rst_n;
    wire o_en;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    or_pipe_32bit dut (
        .clk(clk),
        .i_en(i_en),
        .or_a(or_a),
        .or_b(or_b),
        .rst_n(rst_n),
        .o_en(o_en),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            i_en = 0;
            or_a = 32'h0;
            or_b = 32'h0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: 0x0 | 0x0");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            i_en = 1'b1;
            or_a = 32'h0000_0000;
            or_b = 32'h0000_0000;
            @(posedge clk);
            i_en = 1'b0;


            while (o_en !== 1'b1) @(posedge clk);
            #1;

            check_outputs(1'b1, 32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: 0xFFFFFFFF | 0x0");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            i_en = 1'b1;
            or_a = 32'hFFFF_FFFF;
            or_b = 32'h0000_0000;
            @(posedge clk);
            i_en = 1'b0;

            while (o_en !== 1'b1) @(posedge clk);
            #1;

            check_outputs(1'b1, 32'hFFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: 0xAAAAAAAA | 0x55555555");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            i_en = 1'b1;
            or_a = 32'hAAAA_AAAA;
            or_b = 32'h5555_5555;
            @(posedge clk);
            i_en = 1'b0;

            while (o_en !== 1'b1) @(posedge clk);
            #1;

            check_outputs(1'b1, 32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: 0x12345678 | 0x9ABCDEF0");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            i_en = 1'b1;
            or_a = 32'h1234_5678;
            or_b = 32'h9ABC_DEF0;
            @(posedge clk);
            i_en = 1'b0;

            while (o_en !== 1'b1) @(posedge clk);
            #1;

            check_outputs(1'b1, 32'h9ABC_DEF8);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: 0xFFFF0000 | 0x0000FFFF");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            i_en = 1'b1;
            or_a = 32'hFFFF_0000;
            or_b = 32'h0000_FFFF;
            @(posedge clk);
            i_en = 1'b0;

            while (o_en !== 1'b1) @(posedge clk);
            #1;

            check_outputs(1'b1, 32'hFFFF_FFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("or_pipe_32bit Testbench");
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
        input expected_o_en;
        input [31:0] expected_result;
        begin
            if (expected_o_en === (expected_o_en ^ o_en ^ expected_o_en) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: o_en=%b, result=%h",
                         o_en, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_en=%b, result=%h",
                         expected_o_en, expected_result);
                $display("  Got:      o_en=%b, result=%h",
                         o_en, result);
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
        $dumpvars(0,clk, i_en, or_a, or_b, rst_n, o_en, result);
    end

endmodule
