`timescale 1ns/1ps

module VCO_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] ctrl;
    reg reset;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VCO dut (
        .clk(clk),
        .ctrl(ctrl),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ctrl = 0;
            counting = 0;
            edge_count = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify oscillation at low ctrl (ctrl=2)", test_num);
            reset_dut();

            ctrl = 4'd2;
            #50;

            edge_count = 0;
            counting = 1;
            #1000;
            counting = 0;

            $display("  Edges detected: %0d", edge_count);

            if (edge_count > 0)
                #1;

                check_outputs(out);
            else
                #1;

                check_outputs(!out);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verify oscillation at high ctrl (ctrl=14)", test_num);
            reset_dut();

            ctrl = 4'd14;
            #50;

            edge_count = 0;
            counting = 1;
            #1000;
            counting = 0;

            $display("  Edges detected: %0d", edge_count);
            if (edge_count > 0)
                #1;

                check_outputs(out);
            else
                #1;

                check_outputs(!out);
        end
        endtask

    task testcase003;

        integer count_low, count_high;
        begin
            test_num = 3;
            $display("Testcase %0d: Verify frequency increases with ctrl value", test_num);


            reset_dut();
            ctrl = 4'd1;
            #50;
            edge_count = 0;
            counting = 1;
            #1000;
            counting = 0;
            count_low = edge_count;


            reset_dut();
            ctrl = 4'd15;
            #50;
            edge_count = 0;
            counting = 1;
            #1000;
            counting = 0;
            count_high = edge_count;

            $display("  ctrl=1 count: %0d, ctrl=15 count: %0d", count_low, count_high);


            if (count_high > count_low)
                #1;

                check_outputs(out);
            else
                #1;

                check_outputs(!out);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VCO Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        $dumpvars(0,clk, ctrl, reset, out);
    end

endmodule
