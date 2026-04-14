`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [5:0] i_rd_addr_a;
    reg [5:0] i_rd_addr_b;
    reg [5:0] i_rd_addr_c;
    reg [5:0] i_rd_addr_d;
    reg i_reset;
    reg i_wen;
    reg [5:0] i_wr_addr_a;
    reg [5:0] i_wr_addr_b;
    reg [31:0] i_wr_data_a;
    reg [31:0] i_wr_data_b;
    wire [31:0] o_rd_data_a;
    wire [31:0] o_rd_data_b;
    wire [31:0] o_rd_data_c;
    wire [31:0] o_rd_data_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_rd_addr_a(i_rd_addr_a),
        .i_rd_addr_b(i_rd_addr_b),
        .i_rd_addr_c(i_rd_addr_c),
        .i_rd_addr_d(i_rd_addr_d),
        .i_reset(i_reset),
        .i_wen(i_wen),
        .i_wr_addr_a(i_wr_addr_a),
        .i_wr_addr_b(i_wr_addr_b),
        .i_wr_data_a(i_wr_data_a),
        .i_wr_data_b(i_wr_data_b),
        .o_rd_data_a(o_rd_data_a),
        .o_rd_data_b(o_rd_data_b),
        .o_rd_data_c(o_rd_data_c),
        .o_rd_data_d(o_rd_data_d)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_reset = 1;
            i_wen = 0;
            i_wr_addr_a = 0;
            i_wr_addr_b = 0;
            i_wr_data_a = 0;
            i_wr_data_b = 0;
            i_rd_addr_a = 0;
            i_rd_addr_b = 0;
            i_rd_addr_c = 0;
            i_rd_addr_d = 0;
            @(posedge i_clk);
            #2 i_reset = 0;
            @(posedge i_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();

            i_rd_addr_a = 6'd0;
            i_rd_addr_b = 6'd10;
            i_rd_addr_c = 6'd25;
            i_rd_addr_d = 6'd39;


            @(posedge i_clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simultaneous Dual Write", test_num);
            reset_dut();


            @(posedge i_clk);
            i_wen = 1;
            i_wr_addr_a = 6'd5;
            i_wr_data_a = 32'hDEADBEEF;
            i_wr_addr_b = 6'd15;
            i_wr_data_b = 32'hCAFEBABE;

            @(posedge i_clk);
            i_wen = 0;


            i_rd_addr_a = 6'd5;
            i_rd_addr_b = 6'd15;
            i_rd_addr_c = 6'd0;
            i_rd_addr_d = 6'd0;

            @(posedge i_clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 32'hCAFEBABE, 32'h0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Four Port Concurrent Read", test_num);
            reset_dut();


            @(posedge i_clk);
            i_wen = 1;
            i_wr_addr_a = 6'd1; i_wr_data_a = 32'h11111111;
            i_wr_addr_b = 6'd2; i_wr_data_b = 32'h22222222;
            @(posedge i_clk);

            i_wr_addr_a = 6'd3; i_wr_data_a = 32'h33333333;
            i_wr_addr_b = 6'd4; i_wr_data_b = 32'h44444444;
            @(posedge i_clk);
            i_wen = 0;


            i_rd_addr_a = 6'd1;
            i_rd_addr_b = 6'd2;
            i_rd_addr_c = 6'd3;
            i_rd_addr_d = 6'd4;

            @(posedge i_clk);
            #2;
            #1;

            check_outputs(32'h11111111, 32'h22222222, 32'h33333333, 32'h44444444);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write Enable Check", test_num);
            reset_dut();


            @(posedge i_clk);
            i_wen = 0;
            i_wr_addr_a = 6'd20;
            i_wr_data_a = 32'hFFFFFFFF;

            @(posedge i_clk);
            i_rd_addr_a = 6'd20;

            @(posedge i_clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary Addresses (0 and 39)", test_num);
            reset_dut();

            @(posedge i_clk);
            i_wen = 1;
            i_wr_addr_a = 6'd0;
            i_wr_data_a = 32'hAAAA5555;
            i_wr_addr_b = 6'd39;
            i_wr_data_b = 32'h5555AAAA;

            @(posedge i_clk);
            i_wen = 0;
            i_rd_addr_c = 6'd0;
            i_rd_addr_d = 6'd39;

            @(posedge i_clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 32'hAAAA5555, 32'h5555AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Overwrite Verification", test_num);
            reset_dut();

            @(posedge i_clk);
            i_wen = 1;
            i_wr_addr_a = 6'd12;
            i_wr_data_a = 32'h00001111;
            @(posedge i_clk);
            i_wr_addr_a = 6'd12;
            i_wr_data_a = 32'h99998888;
            @(posedge i_clk);
            i_wen = 0;

            i_rd_addr_a = 6'd12;
            @(posedge i_clk);
            #2;
            #1;

            check_outputs(32'h99998888, 32'h0, 32'h0, 32'h0);
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
        input [31:0] expected_o_rd_data_a;
        input [31:0] expected_o_rd_data_b;
        input [31:0] expected_o_rd_data_c;
        input [31:0] expected_o_rd_data_d;
        begin
            if (expected_o_rd_data_a === (expected_o_rd_data_a ^ o_rd_data_a ^ expected_o_rd_data_a) &&
                expected_o_rd_data_b === (expected_o_rd_data_b ^ o_rd_data_b ^ expected_o_rd_data_b) &&
                expected_o_rd_data_c === (expected_o_rd_data_c ^ o_rd_data_c ^ expected_o_rd_data_c) &&
                expected_o_rd_data_d === (expected_o_rd_data_d ^ o_rd_data_d ^ expected_o_rd_data_d)) begin
                $display("PASS");
                $display("  Outputs: o_rd_data_a=%h, o_rd_data_b=%h, o_rd_data_c=%h, o_rd_data_d=%h",
                         o_rd_data_a, o_rd_data_b, o_rd_data_c, o_rd_data_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_rd_data_a=%h, o_rd_data_b=%h, o_rd_data_c=%h, o_rd_data_d=%h",
                         expected_o_rd_data_a, expected_o_rd_data_b, expected_o_rd_data_c, expected_o_rd_data_d);
                $display("  Got:      o_rd_data_a=%h, o_rd_data_b=%h, o_rd_data_c=%h, o_rd_data_d=%h",
                         o_rd_data_a, o_rd_data_b, o_rd_data_c, o_rd_data_d);
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
        $dumpvars(0,i_clk, i_rd_addr_a, i_rd_addr_b, i_rd_addr_c, i_rd_addr_d, i_reset, i_wen, i_wr_addr_a, i_wr_addr_b, i_wr_data_a, i_wr_data_b, o_rd_data_a, o_rd_data_b, o_rd_data_c, o_rd_data_d);
    end

endmodule
