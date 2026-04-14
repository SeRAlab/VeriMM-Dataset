`timescale 1ns/1ps

module vco_tb;

    // Testbench signals (sequential circuit)
    reg ctrl;
    wire clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vco dut (
        .ctrl(ctrl),
        .clk(clk)
    );

    // Clock generation (10ns period)
    initial begin
        ctrl = 0;
        forever #5 ctrl = ~ctrl;
    end

        task reset_dut;

        begin
            ctrl = 0;


            #100;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Base Frequency (ctrl=0), 0.5 cycle check", test_num);
            reset_dut();
            ctrl = 0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Base Frequency (ctrl=0), 1.0 cycle check", test_num);
            reset_dut();
            ctrl = 0;
            #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Double Frequency (ctrl=1), 0.5 cycle check", test_num);
            reset_dut();
            ctrl = 1;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Double Frequency (ctrl=1), 1.0 cycle check", test_num);
            reset_dut();
            ctrl = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Frequency Comparison check", test_num);
            reset_dut();
            ctrl = 1;
            #20;
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
        $display("vco Testbench");
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
        input expected_clk;
        begin
            if (expected_clk === (expected_clk ^ clk ^ expected_clk)) begin
                $display("PASS");
                $display("  Outputs: clk=%b",
                         clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk=%b",
                         expected_clk);
                $display("  Got:      clk=%b",
                         clk);
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
        $dumpvars(0,ctrl, clk);
    end

endmodule
