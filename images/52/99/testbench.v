`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dbus;
    reg ena_;
    reg [7:0] pc_dout;
    reg rst_;
    wire [7:0] abus;
    wire [7:0] inst;
    wire mem_re_;
    wire [7:0] pc_din;
    wire pc_we_;
    wire rdy_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dbus(dbus),
        .ena_(ena_),
        .pc_dout(pc_dout),
        .rst_(rst_),
        .abus(abus),
        .inst(inst),
        .mem_re_(mem_re_),
        .pc_din(pc_din),
        .pc_we_(pc_we_),
        .rdy_(rdy_)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_ = 0;
            ena_ = 1;
            dbus = 8'h00;
            pc_dout = 8'h00;
            @(posedge clk);
            #2 rst_ = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Instruction Fetch", test_num);
            reset_dut();


            ena_ = 0;
            pc_dout = 8'h10;


            @(posedge clk);
            #1;
            dbus = 8'hA5;


            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h10, 8'hA5, 1'b1, 8'h11, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Instruction Fetch at 0x25", test_num);
            reset_dut();

            ena_ = 0;
            pc_dout = 8'h25;

            @(posedge clk);
            #1;
            dbus = 8'h3C;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h25, 8'h3C, 1'b1, 8'h26, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: PC Rollover at 0xFF", test_num);
            reset_dut();

            ena_ = 0;
            pc_dout = 8'hFF;

            @(posedge clk);
            #1;
            dbus = 8'hEE;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'hFF, 8'hEE, 1'b1, 8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Module Disabled (ena_=1)", test_num);
            reset_dut();

            ena_ = 1;
            pc_dout = 8'h10;

            @(posedge clk);
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h10, 8'h00, 1'b1, 8'h11, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Post-Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00, 8'h00, 1'b1, 8'h01, 1'b1, 1'b0);
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
        input [7:0] expected_abus;
        input [7:0] expected_inst;
        input expected_mem_re_;
        input [7:0] expected_pc_din;
        input expected_pc_we_;
        input expected_rdy_;
        begin
            if (expected_abus === (expected_abus ^ abus ^ expected_abus) &&
                expected_inst === (expected_inst ^ inst ^ expected_inst) &&
                expected_mem_re_ === (expected_mem_re_ ^ mem_re_ ^ expected_mem_re_) &&
                expected_pc_din === (expected_pc_din ^ pc_din ^ expected_pc_din) &&
                expected_pc_we_ === (expected_pc_we_ ^ pc_we_ ^ expected_pc_we_) &&
                expected_rdy_ === (expected_rdy_ ^ rdy_ ^ expected_rdy_)) begin
                $display("PASS");
                $display("  Outputs: abus=%h, inst=%h, mem_re_=%b, pc_din=%h, pc_we_=%b, rdy_=%b",
                         abus, inst, mem_re_, pc_din, pc_we_, rdy_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: abus=%h, inst=%h, mem_re_=%b, pc_din=%h, pc_we_=%b, rdy_=%b",
                         expected_abus, expected_inst, expected_mem_re_, expected_pc_din, expected_pc_we_, expected_rdy_);
                $display("  Got:      abus=%h, inst=%h, mem_re_=%b, pc_din=%h, pc_we_=%b, rdy_=%b",
                         abus, inst, mem_re_, pc_din, pc_we_, rdy_);
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
        $dumpvars(0,clk, dbus, ena_, pc_dout, rst_, abus, inst, mem_re_, pc_din, pc_we_, rdy_);
    end

endmodule
