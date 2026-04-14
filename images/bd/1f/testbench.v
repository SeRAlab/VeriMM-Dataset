`timescale 1ns/1ps

module coffee_machine_tb;

    // Testbench signals (sequential circuit)
    reg brew;
    reg clk;
    reg resetn;
    reg stop;
    wire brewing;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    coffee_machine dut (
        .brew(brew),
        .clk(clk),
        .resetn(resetn),
        .stop(stop),
        .brewing(brewing)
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
            brew = 0;
            stop = 0;
            @(negedge clk);
            resetn = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial state after reset");
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Start brewing signal");
            reset_dut();
            @(negedge clk);
            brew = 1;
            @(negedge clk);
            brew = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Stop brewing signal");
            reset_dut();
            @(negedge clk);
            brew = 1;
            @(negedge clk);
            brew = 0;
            stop = 1;
            @(negedge clk);
            stop = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Verify brewing remains active without continuous brew signal");
            reset_dut();
            @(negedge clk);
            brew = 1;
            @(negedge clk);
            brew = 0;
            repeat(3) @(negedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Simultaneous brew and stop signals");
            reset_dut();
            @(negedge clk);
            brew = 1;
            stop = 1;
            @(negedge clk);
            @(posedge clk);
            #1 #1;
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
        $display("coffee_machine Testbench");
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
        input expected_brewing;
        begin
            if (expected_brewing === (expected_brewing ^ brewing ^ expected_brewing)) begin
                $display("PASS");
                $display("  Outputs: brewing=%b",
                         brewing);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: brewing=%b",
                         expected_brewing);
                $display("  Got:      brewing=%b",
                         brewing);
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
        $dumpvars(0,brew, clk, resetn, stop, brewing);
    end

endmodule
