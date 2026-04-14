`timescale 1ns/1ps

module sprinkler_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg resetn;
    wire sprinkling;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sprinkler_system dut (
        .clk(clk),
        .enable(enable),
        .resetn(resetn),
        .sprinkling(sprinkling)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            resetn = 0;
            enable = 0;
            @(negedge clk);
            resetn = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verification of initial state after reset", test_num);
            reset_dut();
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable sprinkling system", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: System should remain idle when enable is low", test_num);
            reset_dut();
            @(negedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset system during active sprinkling", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            @(posedge clk);
            @(negedge clk);
            resetn = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Re-enable system after a reset cycle", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat(2) @(posedge clk);
            @(negedge clk);
            resetn = 0;
            @(negedge clk);
            resetn = 1;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sprinkler_system Testbench");
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
        input expected_sprinkling;
        begin
            if (expected_sprinkling === (expected_sprinkling ^ sprinkling ^ expected_sprinkling)) begin
                $display("PASS");
                $display("  Outputs: sprinkling=%b",
                         sprinkling);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sprinkling=%b",
                         expected_sprinkling);
                $display("  Got:      sprinkling=%b",
                         sprinkling);
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
        $dumpvars(0,clk, enable, resetn, sprinkling);
    end

endmodule
