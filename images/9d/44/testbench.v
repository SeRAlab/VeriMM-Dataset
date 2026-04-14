`timescale 1ns/1ps

module pedestrian_crossing_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pedestrian;
    reg resetn;
    wire walk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pedestrian_crossing dut (
        .clk(clk),
        .pedestrian(pedestrian),
        .resetn(resetn),
        .walk(walk)
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
            pedestrian = 0;
            @(negedge clk);
            resetn = 1;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Request Walk", test_num);
            reset_dut();
            @(negedge clk);
            pedestrian = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: No Pedestrian Request", test_num);
            reset_dut();
            pedestrian = 0;
            repeat (3) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Signal returns to 0 after pedestrian is gone", test_num);
            reset_dut();
            @(negedge clk);
            pedestrian = 1;
            @(posedge clk);
            @(negedge clk);
            pedestrian = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Synchronous Reset Mid-Walk", test_num);
            reset_dut();
            @(negedge clk);
            pedestrian = 1;
            @(posedge clk);
            @(negedge clk);
            resetn = 0;
            @(posedge clk);
            #2;
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
        $display("pedestrian_crossing Testbench");
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
        input expected_walk;
        begin
            if (expected_walk === (expected_walk ^ walk ^ expected_walk)) begin
                $display("PASS");
                $display("  Outputs: walk=%b",
                         walk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: walk=%b",
                         expected_walk);
                $display("  Got:      walk=%b",
                         walk);
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
        $dumpvars(0,clk, pedestrian, resetn, walk);
    end

endmodule
