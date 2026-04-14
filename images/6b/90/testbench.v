`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [31:0] io_br;
    reg [31:0] io_jmp;
    reg [1:0] io_jmp_br_mux_sel;
    reg reset;
    wire [31:0] io_to_adder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_br(io_br),
        .io_jmp(io_jmp),
        .io_jmp_br_mux_sel(io_jmp_br_mux_sel),
        .reset(reset),
        .io_to_adder(io_to_adder)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select io_jmp (sel=0)", test_num);

            reset = 1;
            clock = 0;
            #10;
            reset = 0;
            #10;

            io_jmp = 32'h12345678;
            io_br  = 32'h9ABCDEF0;
            io_jmp_br_mux_sel = 2'b00;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select io_br (sel=1)", test_num);

            reset = 1;
            #10;
            reset = 0;
            #10;

            io_jmp = 32'h12345678;
            io_br  = 32'h9ABCDEF0;
            io_jmp_br_mux_sel = 2'b01;

            #1;


            check_outputs(32'h9ABCDEF0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select io_jmp (sel=0) - All Ones", test_num);

            reset = 1;
            #10;
            reset = 0;
            #10;

            io_jmp = 32'hFFFFFFFF;
            io_br  = 32'h00000000;
            io_jmp_br_mux_sel = 2'b00;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select io_br (sel=1) - All Zeros", test_num);

            reset = 1;
            #10;
            reset = 0;
            #10;

            io_jmp = 32'hFFFFFFFF;
            io_br  = 32'h00000000;
            io_jmp_br_mux_sel = 2'b01;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select io_jmp (sel=0) - Alternating bits", test_num);

            reset = 1;
            #10;
            reset = 0;
            #10;

            io_jmp = 32'hA5A5A5A5;
            io_br  = 32'h5A5A5A5A;
            io_jmp_br_mux_sel = 2'b00;

            #1;


            check_outputs(32'hA5A5A5A5);
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
        input [31:0] expected_io_to_adder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_to_adder === (expected_io_to_adder ^ io_to_adder ^ expected_io_to_adder)) begin
                $display("PASS");
                $display("  Outputs: io_to_adder=%h",
                         io_to_adder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_to_adder=%h",
                         expected_io_to_adder);
                $display("  Got:      io_to_adder=%h",
                         io_to_adder);
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
