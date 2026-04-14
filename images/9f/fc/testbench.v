`timescale 1ns/1ps

module register_with_async_reset_n_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    wire [7:0] reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_with_async_reset_n dut (
        .clk(clk),
        .reset_n(reset_n),
        .reg_out(reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            #15;
            reset_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying immediate asynchronous reset", test_num);

            reset_n = 1;
            #2;

            reset_n = 0;
            #1;
            #1;

            check_outputs(8'h00);
            reset_n = 1;
            #5;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying value persistence after reset release", test_num);
            reset_dut();


            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying async reset during clock high phase", test_num);
            reset_n = 1;


            wait(clk === 1);
            #2;
            reset_n = 0;
            #1;

            #1;


            check_outputs(8'h00);
            reset_n = 1;
            #5;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying async reset during clock low phase", test_num);
            reset_n = 1;


            wait(clk === 0);
            #2;
            reset_n = 0;
            #1;

            #1;


            check_outputs(8'h00);
            reset_n = 1;
            #5;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_with_async_reset_n Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [7:0] expected_reg_out;
        begin
            if (expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out)) begin
                $display("PASS");
                $display("  Outputs: reg_out=%h",
                         reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_out=%h",
                         expected_reg_out);
                $display("  Got:      reg_out=%h",
                         reg_out);
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
        $dumpvars(0,clk, reset_n, reg_out);
    end

endmodule
