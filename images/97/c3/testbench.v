`timescale 1ns/1ps

module heater_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg resetn;
    wire heating;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    heater_system dut (
        .clk(clk),
        .enable(enable),
        .resetn(resetn),
        .heating(heating)
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
            @(posedge clk);
            #1;
            resetn = 1;
            $display("Reset complete.");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Heater ON verification...");
            reset_dut();
            @(negedge clk);
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Heater OFF verification...");
            reset_dut();
            @(negedge clk);
            enable = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Heater transition ON -> OFF...");
            reset_dut();

            @(negedge clk);
            enable = 1;
            @(posedge clk);

            @(negedge clk);
            enable = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Synchronous reset while operating...");
            reset_dut();

            @(negedge clk);
            enable = 1;
            @(posedge clk);
            #1;

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
            $display("\nRunning testcase005: Multiple cycles verification...");
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat (5) @(posedge clk);
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
        $display("heater_system Testbench");
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
        $dumpvars(0,clk, enable, resetn, heating);
    end

endmodule
