`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [7:0] fric_in;
    reg [7:0] fric_out;
    reg rst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fric_in(fric_in),
        .fric_out(fric_out),
        .rst(rst)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Functionality", test_num);
            rst = 1;
            fric_in = 8'hFF;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
            rst = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Data Propagation", test_num);
            rst = 0;
            fric_in = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Successive Data Changes", test_num);
            rst = 0;
            fric_in = 8'h12; @(posedge clk);
            fric_in = 8'h34; @(posedge clk);
            fric_in = 8'h56; @(posedge clk);
            #1;
            #1;

            check_outputs(8'h56);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Boundary Values", test_num);
            rst = 0;
            fric_in = 8'hFF; @(posedge clk);
            #1;
            if (fric_out !== 8'hFF) begin
                #1;

                check_outputs(8'hFF);
            end else begin
                fric_in = 8'h00; @(posedge clk);
                #1;
                #1;

                check_outputs(8'h00);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset Override", test_num);
            rst = 0;
            fric_in = 8'h77; @(posedge clk);
            #1;
            rst = 1;
            fric_in = 8'hBB; @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
            rst = 0;
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
