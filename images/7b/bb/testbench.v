`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] btb_target;
    reg [1:0] btb_type;
    reg btb_v;
    reg clk;
    reg [31:0] good_target;
    reg id_pc_src;
    reg pc_go;
    reg [31:0] ras_target;
    reg rst;
    reg stall;
    wire [31:0] pc_out;
    wire [31:0] pc_plus4;
    wire v_pc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .btb_target(btb_target),
        .btb_type(btb_type),
        .btb_v(btb_v),
        .clk(clk),
        .good_target(good_target),
        .id_pc_src(id_pc_src),
        .pc_go(pc_go),
        .ras_target(ras_target),
        .rst(rst),
        .stall(stall),
        .pc_out(pc_out),
        .pc_plus4(pc_plus4),
        .v_pc_out(v_pc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            btb_target = 0;
            btb_type = 0;
            btb_v = 0;
            good_target = 0;
            id_pc_src = 0;
            pc_go = 0;
            ras_target = 0;
            stall = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h4, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Linear PC Incrementing", test_num);
            reset_dut();
            pc_go = 1;
            stall = 0;
            id_pc_src = 0;
            btb_v = 0;


            @(posedge clk);

            @(posedge clk);

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_000c, 32'h0000_0010, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: BTB Prediction", test_num);
            reset_dut();
            pc_go = 1;
            btb_v = 1;
            btb_type = 2'b01;
            btb_target = 32'h0000_1000;


            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_1000, 32'h0000_1004, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: RAS Return Prediction", test_num);
            reset_dut();
            pc_go = 1;
            btb_v = 1;
            btb_type = 2'b10;
            ras_target = 32'h0000_2000;


            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_2000, 32'h0000_2004, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Stall Logic", test_num);
            reset_dut();
            pc_go = 1;

            @(posedge clk);

            #1 stall = 1;
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0000_0004, 32'h0000_0008, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: ID PC Source Correction", test_num);
            reset_dut();
            pc_go = 1;

            btb_v = 1;
            btb_type = 2'b01;
            btb_target = 32'hFFFF_0000;

            id_pc_src = 1;
            good_target = 32'h0000_ABCD;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0000_ABCD, 32'h0000_ABD1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: PC Valid Output (pc_go)", test_num);
            reset_dut();
            pc_go = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(pc_out, pc_plus4, 1'b0);
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
        input [31:0] expected_pc_plus4;
        input expected_v_pc_out;
        begin
            if (expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out) &&
                expected_pc_plus4 === (expected_pc_plus4 ^ pc_plus4 ^ expected_pc_plus4) &&
                expected_v_pc_out === (expected_v_pc_out ^ v_pc_out ^ expected_v_pc_out)) begin
                $display("PASS");
                $display("  Outputs: pc_out=%h, pc_plus4=%h, v_pc_out=%b",
                         pc_out, pc_plus4, v_pc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_out=%h, pc_plus4=%h, v_pc_out=%b",
                         expected_pc_out, expected_pc_plus4, expected_v_pc_out);
                $display("  Got:      pc_out=%h, pc_plus4=%h, v_pc_out=%b",
                         pc_out, pc_plus4, v_pc_out);
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
        $dumpvars(0,btb_target, btb_type, btb_v, clk, good_target, id_pc_src, pc_go, ras_target, rst, stall, pc_out, pc_plus4, v_pc_out);
    end

endmodule
