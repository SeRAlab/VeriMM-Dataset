`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] in;
    reg sel;
    wire [7:0] out_always;
    wire [2:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .sel(sel),
        .out_always(out_always),
        .pos(pos)
    );

    // Clock generation (10ns period)
    initial begin
        sel = 0;
        forever #5 sel = ~sel;
    end

        task reset_dut;

        begin
            in = 8'h00;

            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 0 set, sel = 0 (Expect: out=in, pos=0)", test_num);
            in = 8'b0000_0001;

            wait(sel == 1'b0);
            #2;
            #1;

            check_outputs(8'h01, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 0 set, sel = 1 (Expect: out=pos, pos=0)", test_num);
            in = 8'b0000_0001;
            wait(sel == 1'b1);
            #2;
            #1;

            check_outputs(8'h00, 3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 7 set, sel = 0 (Expect: out=in, pos=7)", test_num);
            in = 8'b1000_0000;
            wait(sel == 1'b0);
            #2;
            #1;

            check_outputs(8'h80, 3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 7 set, sel = 1 (Expect: out=pos, pos=7)", test_num);
            in = 8'b1000_0000;
            wait(sel == 1'b1);
            #2;
            #1;

            check_outputs(8'h07, 3'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple bits (6, 4, 2), sel = 1 (Expect: out=pos=6)", test_num);
            in = 8'b0101_0100;
            wait(sel == 1'b1);
            #2;
            #1;

            check_outputs(8'h06, 3'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple bits (3, 0), sel = 0 (Expect: out=in)", test_num);
            in = 8'b0000_1001;
            wait(sel == 1'b0);
            #2;
            #1;

            check_outputs(8'h09, 3'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 4 set, sel = 1 (Expect: out=pos=4)", test_num);
            in = 8'b0001_0000;
            wait(sel == 1'b1);
            #2;
            #1;

            check_outputs(8'h04, 3'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All bits set, sel = 1 (Expect: out=pos=7)", test_num);
            in = 8'hFF;
            wait(sel == 1'b1);
            #2;
            #1;

            check_outputs(8'h07, 3'd7);
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
        testcase008();
        
        
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
        input [7:0] expected_out_always;
        input [2:0] expected_pos;
        begin
            if (expected_out_always === (expected_out_always ^ out_always ^ expected_out_always) &&
                expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: out_always=%h, pos=%h",
                         out_always, pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_always=%h, pos=%h",
                         expected_out_always, expected_pos);
                $display("  Got:      out_always=%h, pos=%h",
                         out_always, pos);
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
        $dumpvars(0,in, sel, out_always, pos);
    end

endmodule
