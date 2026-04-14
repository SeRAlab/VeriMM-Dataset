`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg d_in;
    wire d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d_in(d_in),
        .d_out(d_out)
    );
    task reset_circuit;

        begin
            d_in = 0;
            clk = 0;
            #10;
            clk = 1; #10; clk = 0; #10;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Driving d_in=0, checking d_out is 0", test_num);
            reset_circuit();

            d_in = 0;
            #5;
            clk = 1; #5; clk = 0; #5;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Driving d_in=1 to set internal state b", test_num);
            reset_circuit();


            d_in = 1;
            #5;
            clk = 1; #5; clk = 0; #5;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking if d_out stays high when d_in remains 1", test_num);

            d_in = 1;
            #5;
            clk = 1; #5; clk = 0; #5;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Driving d_in=0, checking if d_out goes low immediately", test_num);

            d_in = 0;
            #5;
            clk = 1; #5; clk = 0; #5;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Toggle test - d_in high then low", test_num);
            reset_circuit();


            d_in = 1;
            #5; clk = 1; #5; clk = 0; #5;


            d_in = 0;
            #5; clk = 1; #5; clk = 0; #5;

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
        input expected_d_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%b",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%b",
                         expected_d_out);
                $display("  Got:      d_out=%b",
                         d_out);
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
