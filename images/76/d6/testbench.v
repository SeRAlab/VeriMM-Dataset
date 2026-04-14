`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [143:0] port0_ci;
    reg [143:0] port1_ci;
    reg [143:0] port2_ci;
    reg [143:0] port3_ci;
    reg [143:0] port4_ci;
    reg port4_ready;
    reg rst;
    wire [143:0] control_w;
    wire [143:0] port0_co;
    wire [143:0] port1_co;
    wire [143:0] port2_co;
    wire [143:0] port3_co;
    wire port4_ack;
    wire [143:0] port4_co;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .port0_ci(port0_ci),
        .port1_ci(port1_ci),
        .port2_ci(port2_ci),
        .port3_ci(port3_ci),
        .port4_ci(port4_ci),
        .port4_ready(port4_ready),
        .rst(rst),
        .control_w(control_w),
        .port0_co(port0_co),
        .port1_co(port1_co),
        .port2_co(port2_co),
        .port3_co(port3_co),
        .port4_ack(port4_ack),
        .port4_co(port4_co)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            port0_ci = 0;
            port1_ci = 0;
            port2_ci = 0;
            port3_ci = 0;
            port4_ci = 0;
            port4_ready = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Power-on Reset", test_num);
            reset_dut();

            #1;


            check_outputs(144'h0, 144'h0, 144'h0, 144'h0, 144'h0, 1'b0, 144'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Basic Data Forwarding and Control OR", test_num);
            reset_dut();

            port0_ci = 144'h1;
            port1_ci = 144'h2;
            port2_ci = 144'h4;
            port3_ci = 144'h8;
            port4_ci = 144'h10;
            port4_ready = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(144'h1F, 144'h1, 144'h2, 144'h4, 144'h8, 1'b0, 144'h10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Port4 Ready-Ack Handshake", test_num);
            reset_dut();

            port4_ready = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(144'h0, 144'h0, 144'h0, 144'h0, 144'h0, 1'b1, 144'h0);

            port4_ready = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(144'h0, 144'h0, 144'h0, 144'h0, 144'h0, 1'b0, 144'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Complex Bitwise OR logic", test_num);
            reset_dut();

            port0_ci = 144'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            port1_ci = 144'h555555555555555555555555555555555555;
            port2_ci = 144'h0;
            port3_ci = 144'hF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0;
            port4_ci = 144'h0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(144'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
                          144'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,
                          144'h555555555555555555555555555555555555,
                          144'h0,
                          144'hF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0,
                          1'b0,
                          144'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: High-bit Data Forwarding (Bit 143)", test_num);
            reset_dut();


            port0_ci = (144'h1 << 143);
            port1_ci = (144'h1 << 142);
            port2_ci = (144'h1 << 72);
            port3_ci = 144'hABCDEF;
            port4_ci = 144'h7;
            port4_ready = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs((144'h1 << 143) | (144'h1 << 142) | (144'h1 << 72) | 144'hABCDEF | 144'h7,
                          (144'h1 << 143),
                          (144'h1 << 142),
                          (144'h1 << 72),
                          144'hABCDEF,
                          1'b1,
                          144'h7);
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
        input [143:0] expected_control_w;
        input [143:0] expected_port0_co;
        input [143:0] expected_port1_co;
        input [143:0] expected_port2_co;
        input [143:0] expected_port3_co;
        input expected_port4_ack;
        input [143:0] expected_port4_co;
        begin
            if (expected_control_w === (expected_control_w ^ control_w ^ expected_control_w) &&
                expected_port0_co === (expected_port0_co ^ port0_co ^ expected_port0_co) &&
                expected_port1_co === (expected_port1_co ^ port1_co ^ expected_port1_co) &&
                expected_port2_co === (expected_port2_co ^ port2_co ^ expected_port2_co) &&
                expected_port3_co === (expected_port3_co ^ port3_co ^ expected_port3_co) &&
                expected_port4_ack === (expected_port4_ack ^ port4_ack ^ expected_port4_ack) &&
                expected_port4_co === (expected_port4_co ^ port4_co ^ expected_port4_co)) begin
                $display("PASS");
                $display("  Outputs: control_w=%h, port0_co=%h, port1_co=%h, port2_co=%h, port3_co=%h, port4_ack=%b, port4_co=%h",
                         control_w, port0_co, port1_co, port2_co, port3_co, port4_ack, port4_co);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_w=%h, port0_co=%h, port1_co=%h, port2_co=%h, port3_co=%h, port4_ack=%b, port4_co=%h",
                         expected_control_w, expected_port0_co, expected_port1_co, expected_port2_co, expected_port3_co, expected_port4_ack, expected_port4_co);
                $display("  Got:      control_w=%h, port0_co=%h, port1_co=%h, port2_co=%h, port3_co=%h, port4_ack=%b, port4_co=%h",
                         control_w, port0_co, port1_co, port2_co, port3_co, port4_ack, port4_co);
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
        $dumpvars(0,clk, port0_ci, port1_ci, port2_ci, port3_ci, port4_ci, port4_ready, rst, control_w, port0_co, port1_co, port2_co, port3_co, port4_ack, port4_co);
    end

endmodule
