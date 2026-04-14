`timescale 1ns/1ps

module counter_with_carry_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire co;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_with_carry dut (
        .clk(clk),
        .co(co),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            force dut.count = 4'b0000;
            @(posedge clk);
            #1;
            release dut.count;
            $display("DUT Reset to 0");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            repeat (1) @(posedge clk);
            #1;
            $display("Testcase %0d: Check count after 1 cycle", test_num);
            #1;

            check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat (8) @(posedge clk);
            #1;
            $display("Testcase %0d: Check count after 8 cycles", test_num);
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat (15) @(posedge clk);
            #1;
            $display("Testcase %0d: Check terminal count (15) and co assertion", test_num);
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat (16) @(posedge clk);
            #1;
            $display("Testcase %0d: Check wrap around to 0", test_num);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat (31) @(posedge clk);
            #1;
            $display("Testcase %0d: Check terminal count after two wrap-arounds", test_num);
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat (20) @(posedge clk);
            #1;
            $display("Testcase %0d: Check count at 20 (Expected 4)", test_num);
            #1;

            check_outputs(1'b0, 4'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_with_carry Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_co;
        input [3:0] expected_count;
        begin
            if (expected_co === (expected_co ^ co ^ expected_co) &&
                expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: co=%b, count=%h",
                         co, count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: co=%b, count=%h",
                         expected_co, expected_count);
                $display("  Got:      co=%b, count=%h",
                         co, count);
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
        $dumpvars(0,clk, co, count);
    end

endmodule
