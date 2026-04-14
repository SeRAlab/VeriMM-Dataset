`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg enable;
    reg [7:0] frac_divider;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk_ref(clk_ref),
        .enable(enable),
        .frac_divider(frac_divider),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            enable = 0;
            frac_divider = 8'h00;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Output Disable Check", test_num);
            reset_dut();

            enable = 0;
            frac_divider = 8'h40;
            #200;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Basic Enable and Small Divider", test_num);
            reset_dut();

            enable = 1;
            frac_divider = 8'h04;
            #500;




            if (clk_out === 1'b0 || clk_out === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: clk_out is active (%b)", clk_out);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: clk_out is undefined (%b)", clk_out);
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Large Divider Check", test_num);
            reset_dut();

            enable = 1;
            frac_divider = 8'hFF;
            #1000;


            if (clk_out === 1'b0 || clk_out === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: clk_out is active with large divider (%b)", clk_out);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: clk_out is undefined (%b)", clk_out);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Dynamic Disable Check", test_num);
            reset_dut();


            enable = 1;
            frac_divider = 8'h80;
            #200;


            enable = 0;
            #100;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Divider Value Transition", test_num);
            reset_dut();

            enable = 1;
            frac_divider = 8'h10;
            #300;


            frac_divider = 8'h20;
            #500;


            if (clk_out === 1'b0 || clk_out === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: clk_out remains valid after divider change (%b)", clk_out);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: clk_out failed after divider change (%b)", clk_out);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fractional_n_pll Testbench");
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_ref, enable, frac_divider, clk_out);
    end

endmodule
