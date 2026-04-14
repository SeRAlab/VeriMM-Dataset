`timescale 1ns/1ps

module heating_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg resetn;
    reg too_cold;
    wire heating;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    heating_system dut (
        .clk(clk),
        .resetn(resetn),
        .too_cold(too_cold),
        .heating(heating)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            too_cold = 0;
            @(posedge clk);
            #1;
            resetn = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial State after Reset (too_cold=0)", test_num);
            reset_dut();
            too_cold = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Heating turns on when too_cold=1", test_num);
            reset_dut();
            too_cold = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Heating turns off when too_cold returns to 0", test_num);
            reset_dut();

            too_cold = 1;
            @(posedge clk);
            #1;

            too_cold = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during active heating", test_num);
            reset_dut();

            too_cold = 1;
            @(posedge clk);
            #1;

            resetn = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Heating stays on during prolonged cold", test_num);
            reset_dut();
            too_cold = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("heating_system Testbench");
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
        input expected_heating;
        begin
            if (expected_heating === (expected_heating ^ heating ^ expected_heating)) begin
                $display("PASS");
                $display("  Outputs: heating=%b",
                         heating);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: heating=%b",
                         expected_heating);
                $display("  Got:      heating=%b",
                         heating);
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
        $dumpvars(0,clk, resetn, too_cold, heating);
    end

endmodule
