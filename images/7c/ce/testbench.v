`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [143:0] flit0c;
    reg [143:0] flit1c;
    reg [143:0] flitl0;
    reg [143:0] flitl1;
    reg rst;
    wire ack0;
    wire ack1;
    wire port0_co;
    wire port1_co;
    wire portl0_co;
    wire portl1_co;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .flit0c(flit0c),
        .flit1c(flit1c),
        .flitl0(flitl0),
        .flitl1(flitl1),
        .rst(rst),
        .ack0(ack0),
        .ack1(ack1),
        .port0_co(port0_co),
        .port1_co(port1_co),
        .portl0_co(portl0_co),
        .portl1_co(portl1_co)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            flit0c = 0;
            flit1c = 0;
            flitl0 = 0;
            flitl1 = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Priority", test_num);
            rst = 1;
            flit0c = {144{1'b1}};
            flit1c = {144{1'b1}};
            flitl0 = {144{1'b1}};
            flitl1 = {144{1'b1}};
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
            rst = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: All inputs non-zero with LSB=1", test_num);
            reset_dut();
            flit0c = 144'h1;
            flit1c = 144'h1;
            flitl0 = 144'h1;
            flitl1 = 144'h1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: All inputs zero", test_num);
            reset_dut();
            flit0c = 144'h0;
            flit1c = 144'h0;
            flitl0 = 144'h0;
            flitl1 = 144'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Ack logic (Non-zero flits, LSB=0)", test_num);
            reset_dut();
            flit0c = 144'h2;
            flit1c = 144'h2;
            flitl0 = 144'h2;
            flitl1 = 144'h2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Mixed LSB values", test_num);
            reset_dut();
            flit0c = 144'h1;
            flit1c = 144'h0;
            flitl0 = 144'h1;
            flitl1 = 144'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 1, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: High order bits only", test_num);
            reset_dut();
            flit0c = (144'h1 << 143);
            flit1c = (144'h1 << 143);
            flitl0 = (144'h1 << 143);
            flitl1 = (144'h1 << 143);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 0, 0, 0, 0);
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
        input expected_ack0;
        input expected_ack1;
        input expected_port0_co;
        input expected_port1_co;
        input expected_portl0_co;
        input expected_portl1_co;
        begin
            if (expected_ack0 === (expected_ack0 ^ ack0 ^ expected_ack0) &&
                expected_ack1 === (expected_ack1 ^ ack1 ^ expected_ack1) &&
                expected_port0_co === (expected_port0_co ^ port0_co ^ expected_port0_co) &&
                expected_port1_co === (expected_port1_co ^ port1_co ^ expected_port1_co) &&
                expected_portl0_co === (expected_portl0_co ^ portl0_co ^ expected_portl0_co) &&
                expected_portl1_co === (expected_portl1_co ^ portl1_co ^ expected_portl1_co)) begin
                $display("PASS");
                $display("  Outputs: ack0=%b, ack1=%b, port0_co=%b, port1_co=%b, portl0_co=%b, portl1_co=%b",
                         ack0, ack1, port0_co, port1_co, portl0_co, portl1_co);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack0=%b, ack1=%b, port0_co=%b, port1_co=%b, portl0_co=%b, portl1_co=%b",
                         expected_ack0, expected_ack1, expected_port0_co, expected_port1_co, expected_portl0_co, expected_portl1_co);
                $display("  Got:      ack0=%b, ack1=%b, port0_co=%b, port1_co=%b, portl0_co=%b, portl1_co=%b",
                         ack0, ack1, port0_co, port1_co, portl0_co, portl1_co);
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
        $dumpvars(0,clk, flit0c, flit1c, flitl0, flitl1, rst, ack0, ack1, port0_co, port1_co, portl0_co, portl1_co);
    end

endmodule
