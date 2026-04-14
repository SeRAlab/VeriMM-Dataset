`timescale 1ns/1ps

module crystal_oscillator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crystal_oscillator dut (
        .clk(clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin



            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        reg start_val;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Checking toggle after 1 clock cycle", test_num);
            start_val = out;

            @(posedge clk);
            #1;


            #1;



            check_outputs(~start_val);
        end
        endtask

    task testcase002;

        reg start_val;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Checking state after 2 clock cycles (Full period)", test_num);
            start_val = out;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(start_val);
        end
        endtask

    task testcase003;

        reg start_val;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Checking toggle after 5 clock cycles (Odd number)", test_num);
            start_val = out;

            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(~start_val);
        end
        endtask

    task testcase004;

        reg start_val;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Checking state after 10 clock cycles (Even number)", test_num);
            start_val = out;

            repeat(10) @(posedge clk);
            #1;


            #1;



            check_outputs(start_val);
        end
        endtask

    task testcase005;

        reg start_val;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Checking toggle after 101 clock cycles (Large odd number)", test_num);
            start_val = out;

            repeat(101) @(posedge clk);
            #1;


            #1;



            check_outputs(~start_val);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crystal_oscillator Testbench");
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
        $dumpvars(0,clk, out);
    end

endmodule
