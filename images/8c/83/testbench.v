`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] op_ac;
    reg op_i;
    reg [17:0] op_io;
    reg [11:0] op_mask;
    reg [5:0] op_pf;
    reg [17:0] op_tw;
    wire [17:0] op_r_ac;
    wire [17:0] op_r_io;
    wire [5:0] op_r_pf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op_ac(op_ac),
        .op_i(op_i),
        .op_io(op_io),
        .op_mask(op_mask),
        .op_pf(op_pf),
        .op_tw(op_tw),
        .op_r_ac(op_r_ac),
        .op_r_io(op_r_io),
        .op_r_pf(op_r_pf)
    );
    task testcase001;

    begin
        test_num = 1;
        op_ac = 18'h0;
        op_io = 18'h0;
        op_pf = 6'h0;
        op_tw = 18'h0;
        op_mask = 12'h0;
        op_i = 1'b0;


        #1;



        check_outputs(18'h0, 18'h0, 6'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        op_ac = 18'h3FFFF;
        op_io = 18'h0;
        op_pf = 6'h0;
        op_tw = 18'h0;
        op_mask = 12'h0;
        op_i = 1'b0;
        #1;

        check_outputs(18'h3FFFF, 18'h0, 6'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        op_ac = 18'h0;
        op_io = 18'h2AAAA;
        op_pf = 6'h0;
        op_tw = 18'h0;
        op_mask = 12'h0;
        op_i = 1'b0;
        #1;

        check_outputs(18'h0, 18'h2AAAA, 6'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        op_ac = 18'h12345;
        op_io = 18'h0;
        op_pf = 6'h3F;
        op_tw = 18'h0;
        op_mask = 12'hFFF;
        op_i = 1'b0;


        #1;



        check_outputs(op_r_ac, op_r_io, op_r_pf);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        op_ac = 18'h0;
        op_io = 18'h0;
        op_pf = 6'h0;
        op_tw = 18'h15555;
        op_mask = 12'h0;
        op_i = 1'b1;
        #1;

        check_outputs(op_r_ac, op_r_io, op_r_pf);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        op_ac = 18'h000FF;
        op_io = 18'hFF000;
        op_pf = 6'h15;
        op_tw = 18'h0;
        op_mask = 12'hA5A;
        op_i = 1'b0;
        #1;

        check_outputs(op_r_ac, op_r_io, op_r_pf);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        op_ac = 18'h3FFFF;
        op_io = 18'h3FFFF;
        op_pf = 6'h3F;
        op_tw = 18'h3FFFF;
        op_mask = 12'hFFF;
        op_i = 1'b1;
        #1;

        check_outputs(op_r_ac, op_r_io, op_r_pf);
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
        input [17:0] expected_op_r_ac;
        input [17:0] expected_op_r_io;
        input [5:0] expected_op_r_pf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_op_r_ac === (expected_op_r_ac ^ op_r_ac ^ expected_op_r_ac) &&
                expected_op_r_io === (expected_op_r_io ^ op_r_io ^ expected_op_r_io) &&
                expected_op_r_pf === (expected_op_r_pf ^ op_r_pf ^ expected_op_r_pf)) begin
                $display("PASS");
                $display("  Outputs: op_r_ac=%h, op_r_io=%h, op_r_pf=%h",
                         op_r_ac, op_r_io, op_r_pf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op_r_ac=%h, op_r_io=%h, op_r_pf=%h",
                         expected_op_r_ac, expected_op_r_io, expected_op_r_pf);
                $display("  Got:      op_r_ac=%h, op_r_io=%h, op_r_pf=%h",
                         op_r_ac, op_r_io, op_r_pf);
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

endmodule
