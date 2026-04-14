`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable_l;
    reg [31:0] in;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable_l(enable_l),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(posedge clock);
            enable_l = 0;
            in = 32'h0;
            @(posedge clock);

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            @(negedge clock);
            enable_l = 0;
            in = 32'hDEADBEEF;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(negedge clock);
            enable_l = 0;
            in = 32'hAAAA_5555;
            @(posedge clock);


            @(negedge clock);
            enable_l = 1;
            in = 32'hFFFF_FFFF;
            @(posedge clock);

            #1;
            #1;

            check_outputs(32'hAAAA_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            @(negedge clock);
            enable_l = 0;
            in = 32'h1111_1111;
            @(posedge clock);

            @(negedge clock);
            in = 32'h2222_2222;
            @(posedge clock);

            @(negedge clock);
            in = 32'h3333_3333;
            @(posedge clock);

            #1;
            #1;

            check_outputs(32'h3333_3333);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            @(negedge clock);
            enable_l = 0;
            in = 32'hFFFF_FFFF;
            @(posedge clock);

            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(negedge clock);
            enable_l = 0;
            in = 32'hCAFE_BABE;
            @(posedge clock);


            @(negedge clock);
            in = 32'h0000_0000;
            @(posedge clock);

            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(negedge clock);
            enable_l = 0;
            in = 32'h1234_5678;
            @(posedge clock);


            @(negedge clock);
            enable_l = 1;
            in = 32'h8765_4321;
            @(posedge clock);


            @(negedge clock);
            enable_l = 0;
            in = 32'hAAAA_BBBB;
            @(posedge clock);

            #1;
            #1;

            check_outputs(32'hAAAA_BBBB);
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
        input [31:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clock, enable_l, in, out);
    end

endmodule
