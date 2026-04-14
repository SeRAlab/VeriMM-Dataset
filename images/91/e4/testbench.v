`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clr;
    reg in0;
    reg in1;
    reg in2;
    reg [1:0] sel;
    reg set;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clr(clr),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .sel(sel),
        .set(set),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clr = 0;
        forever #5 clr = ~clr;
    end

        task reset_dut;

        begin
            set = 0;
            in0 = 0;
            in1 = 0;
            in2 = 0;
            sel = 2'b11;
            @(posedge clr);
            @(negedge clr);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Select in0=1", test_num);
            sel = 2'b00; in0 = 1; in1 = 0; in2 = 0;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Select in1=1", test_num);
            sel = 2'b01; in0 = 0; in1 = 1; in2 = 0;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Select in2=1", test_num);
            sel = 2'b10; in0 = 0; in1 = 0; in2 = 1;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Select '11' (Forced LOW)", test_num);
            sel = 2'b11; in0 = 1; in1 = 1; in2 = 1;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Select in0=0", test_num);
            sel = 2'b00; in0 = 0;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Positive edge on 'set' signal", test_num);
            sel = 2'b11;
            #1;
            set = 1; #1; set = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Positive edge on 'clr' signal", test_num);
            sel = 2'b00; in0 = 1;
            #1;
            @(posedge clr);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: Mux selection change after state set", test_num);

            set = 1; #1; set = 0;

            sel = 2'b00; in0 = 0;
            #2;
            #1;

            check_outputs(1'b0);
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
        $dumpvars(0,clr, in0, in1, in2, sel, set, out);
    end

endmodule
