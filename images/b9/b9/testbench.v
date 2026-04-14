`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [25:0] opcode25_0;
    reg pause_in;
    reg [29:0] pc_new;
    reg [1:0] pc_source;
    reg reset;
    reg take_branch;
    wire [31:0] pc_out;
    wire [31:0] pc_out_plus4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .opcode25_0(opcode25_0),
        .pause_in(pause_in),
        .pc_new(pc_new),
        .pc_source(pc_source),
        .reset(reset),
        .take_branch(take_branch),
        .pc_out(pc_out),
        .pc_out_plus4(pc_out_plus4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            pause_in = 0;
            pc_new = 0;
            take_branch = 0;
            opcode25_0 = 0;
            pc_source = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000, 32'h00000004);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: PC Increment", test_num);
            reset_dut();
            pc_source = 2'b00;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h00000004, 32'h00000008);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Branch Taken", test_num);
            reset_dut();
            pc_source = 2'b01;
            take_branch = 1;
            pc_new = 30'h0000000A;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h00000028, 32'h0000002C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Branch Not Taken", test_num);
            reset_dut();
            pc_source = 2'b01;
            take_branch = 0;
            pc_new = 30'h0000000A;
            @(posedge clk); #1;

            #1;


            check_outputs(32'h00000004, 32'h00000008);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Opcode Jump", test_num);
            reset_dut();

            pc_source = 2'b00;
            @(posedge clk); #1;

            pc_source = 2'b10;
            opcode25_0 = 26'h000000F;


            @(posedge clk); #1;
            #1;

            check_outputs(32'h0000003C, 32'h00000040);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Pause Inhibition", test_num);
            reset_dut();
            pc_source = 2'b00;
            @(posedge clk); #1;

            pause_in = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(32'h00000004, 32'h00000008);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Sequential Increments", test_num);
            reset_dut();
            pc_source = 2'b00;
            repeat(3) @(posedge clk); #1;

            #1;


            check_outputs(32'h0000000C, 32'h00000010);
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
        input [31:0] expected_pc_out;
        input [31:0] expected_pc_out_plus4;
        begin
            if (expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out) &&
                expected_pc_out_plus4 === (expected_pc_out_plus4 ^ pc_out_plus4 ^ expected_pc_out_plus4)) begin
                $display("PASS");
                $display("  Outputs: pc_out=%h, pc_out_plus4=%h",
                         pc_out, pc_out_plus4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_out=%h, pc_out_plus4=%h",
                         expected_pc_out, expected_pc_out_plus4);
                $display("  Got:      pc_out=%h, pc_out_plus4=%h",
                         pc_out, pc_out_plus4);
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
        $dumpvars(0,clk, opcode25_0, pause_in, pc_new, pc_source, reset, take_branch, pc_out, pc_out_plus4);
    end

endmodule
