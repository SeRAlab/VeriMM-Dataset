`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_CLK;
    reg [63:0] i_OP1;
    reg [63:0] i_OP2;
    reg i_RST_n;
    wire [127:0] o_RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_CLK(i_CLK),
        .i_OP1(i_OP1),
        .i_OP2(i_OP2),
        .i_RST_n(i_RST_n),
        .o_RESULT(o_RESULT)
    );

    // Clock generation (10ns period)
    initial begin
        i_CLK = 0;
        forever #5 i_CLK = ~i_CLK;
    end

        task reset_dut;

    begin
        i_RST_n = 0;
        i_OP1 = 0;
        i_OP2 = 0;
        repeat(2) @(posedge i_CLK);
        #1 i_RST_n = 1;
        @(posedge i_CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Multiply by Zero", test_num);
        reset_dut();
        i_OP1 = 64'hDEADBEEFCAFEBABE;
        i_OP2 = 64'h0;
        repeat(2) @(posedge i_CLK);
        #1 #1;
 check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Multiply by One", test_num);
        reset_dut();
        i_OP1 = 64'h123456789ABCDEF0;
        i_OP2 = 64'h1;
        repeat(2) @(posedge i_CLK);
        #1 #1;
 check_outputs(128'h0000000000000000123456789ABCDEF0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Small Integers (123 * 456)", test_num);
        reset_dut();
        i_OP1 = 64'd123;
        i_OP2 = 64'd456;
        repeat(2) @(posedge i_CLK);
        #1 #1;
 check_outputs(128'd56088);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Maximum 64-bit Unsigned Values", test_num);
        reset_dut();
        i_OP1 = 64'hFFFFFFFFFFFFFFFF;
        i_OP2 = 64'hFFFFFFFFFFFFFFFF;
        repeat(2) @(posedge i_CLK);

        #1 #1;
 check_outputs(128'hFFFFFFFFFFFFFFFE0000000000000001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Powers of Two (2^32 * 2^32)", test_num);
        reset_dut();
        i_OP1 = 64'h0000000100000000;
        i_OP2 = 64'h0000000100000000;
        repeat(2) @(posedge i_CLK);
        #1 #1;
 check_outputs(128'h00000000000000010000000000000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Hex Pattern (AAAA... * 5555...)", test_num);
        reset_dut();
        i_OP1 = 64'hAAAAAAAAAAAAAAAA;
        i_OP2 = 64'h5555555555555555;
        repeat(2) @(posedge i_CLK);
        #1 #1;
 check_outputs(128'h38E38E38E38E38E31C71C71C71C71C72);
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
        input [127:0] expected_o_RESULT;
        begin
            if (expected_o_RESULT === (expected_o_RESULT ^ o_RESULT ^ expected_o_RESULT)) begin
                $display("PASS");
                $display("  Outputs: o_RESULT=%h",
                         o_RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_RESULT=%h",
                         expected_o_RESULT);
                $display("  Got:      o_RESULT=%h",
                         o_RESULT);
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
        $dumpvars(0,i_CLK, i_OP1, i_OP2, i_RST_n, o_RESULT);
    end

endmodule
