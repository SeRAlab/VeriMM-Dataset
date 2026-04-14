`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] controls_in;
    reg [31:0] from_alu_data_in;
    reg [31:0] from_mem_data_in;
    reg [4:0] regfile_addr_in;
    reg rst;
    wire [2:0] controls_out;
    wire [31:0] from_alu_data_out;
    wire [31:0] from_mem_data_out;
    wire [4:0] regfile_addr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .controls_in(controls_in),
        .from_alu_data_in(from_alu_data_in),
        .from_mem_data_in(from_mem_data_in),
        .regfile_addr_in(regfile_addr_in),
        .rst(rst),
        .controls_out(controls_out),
        .from_alu_data_out(from_alu_data_out),
        .from_mem_data_out(from_mem_data_out),
        .regfile_addr_out(regfile_addr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        controls_in = 0;
        from_alu_data_in = 0;
        from_mem_data_in = 0;
        regfile_addr_in = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset verification", test_num);
        reset_dut();

        #1;


        check_outputs(3'b000, 32'h0, 32'h0, 5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Capture specific data pattern A", test_num);
        reset_dut();

        controls_in = 3'b101;
        from_mem_data_in = 32'hDEADBEEF;
        from_alu_data_in = 32'hCAFEBABE;
        regfile_addr_in = 5'd15;

        @(posedge clk);
        #2;
        #1;

        check_outputs(3'b101, 32'hCAFEBABE, 32'hDEADBEEF, 5'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Capture specific data pattern B", test_num);
        reset_dut();

        controls_in = 3'b011;
        from_mem_data_in = 32'h12345678;
        from_alu_data_in = 32'h87654321;
        regfile_addr_in = 5'd31;

        @(posedge clk);
        #2;
        #1;

        check_outputs(3'b011, 32'h87654321, 32'h12345678, 5'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: All ones bitwise check", test_num);
        reset_dut();

        controls_in = 3'b111;
        from_mem_data_in = 32'hFFFFFFFF;
        from_alu_data_in = 32'hFFFFFFFF;
        regfile_addr_in = 5'b11111;

        @(posedge clk);
        #2;
        #1;

        check_outputs(3'b111, 32'hFFFFFFFF, 32'hFFFFFFFF, 5'b11111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Alternating bits check", test_num);
        reset_dut();

        controls_in = 3'b010;
        from_mem_data_in = 32'hAAAAAAAA;
        from_alu_data_in = 32'h55555555;
        regfile_addr_in = 5'b01010;

        @(posedge clk);
        #2;
        #1;

        check_outputs(3'b010, 32'h55555555, 32'hAAAAAAAA, 5'b01010);
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
        input [2:0] expected_controls_out;
        input [31:0] expected_from_alu_data_out;
        input [31:0] expected_from_mem_data_out;
        input [4:0] expected_regfile_addr_out;
        begin
            if (expected_controls_out === (expected_controls_out ^ controls_out ^ expected_controls_out) &&
                expected_from_alu_data_out === (expected_from_alu_data_out ^ from_alu_data_out ^ expected_from_alu_data_out) &&
                expected_from_mem_data_out === (expected_from_mem_data_out ^ from_mem_data_out ^ expected_from_mem_data_out) &&
                expected_regfile_addr_out === (expected_regfile_addr_out ^ regfile_addr_out ^ expected_regfile_addr_out)) begin
                $display("PASS");
                $display("  Outputs: controls_out=%h, from_alu_data_out=%h, from_mem_data_out=%h, regfile_addr_out=%h",
                         controls_out, from_alu_data_out, from_mem_data_out, regfile_addr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: controls_out=%h, from_alu_data_out=%h, from_mem_data_out=%h, regfile_addr_out=%h",
                         expected_controls_out, expected_from_alu_data_out, expected_from_mem_data_out, expected_regfile_addr_out);
                $display("  Got:      controls_out=%h, from_alu_data_out=%h, from_mem_data_out=%h, regfile_addr_out=%h",
                         controls_out, from_alu_data_out, from_mem_data_out, regfile_addr_out);
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
        $dumpvars(0,clk, controls_in, from_alu_data_in, from_mem_data_in, regfile_addr_in, rst, controls_out, from_alu_data_out, from_mem_data_out, regfile_addr_out);
    end

endmodule
