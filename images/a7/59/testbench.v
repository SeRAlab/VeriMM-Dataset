`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] in;
    reg reset;
    wire [3:0] comp;
    wire done;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .reset(reset),
        .comp(comp),
        .done(done),
        .out(out)
    );

        task reset_dut;

        begin
            reset = 1;
            in = 8'h00;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Zeros (0x00)", test_num);
            reset_dut();
            in = 8'h00;
            #100;


            #1;



            check_outputs(4'h0, 1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Ones (0xFF)", test_num);
            reset_dut();
            in = 8'hFF;
            #100;

            #1;


            check_outputs(4'hF, 1'b1, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Pattern 0xAA", test_num);
            reset_dut();
            in = 8'hAA;
            #100;

            #1;


            check_outputs(4'hA, 1'b1, 8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Pattern 0x55", test_num);
            reset_dut();
            in = 8'h55;
            #100;
            #1;

            check_outputs(4'h5, 1'b1, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Walking Bit (0x12)", test_num);
            reset_dut();
            in = 8'h12;
            #100;
            #1;

            check_outputs(4'h3, 1'b1, 8'h12);
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
        input [3:0] expected_comp;
        input expected_done;
        input [7:0] expected_out;
        begin
            if (expected_comp === (expected_comp ^ comp ^ expected_comp) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: comp=%h, done=%b, out=%h",
                         comp, done, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp=%h, done=%b, out=%h",
                         expected_comp, expected_done, expected_out);
                $display("  Got:      comp=%h, done=%b, out=%h",
                         comp, done, out);
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
        $dumpvars(0,in, reset, comp, done, out);
    end

endmodule
