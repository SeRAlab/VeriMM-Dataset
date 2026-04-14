`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] count_in;
    reg load;
    reg reset;
    reg up_down;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .count_in(count_in),
        .load(load),
        .reset(reset),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            load = 0;
            up_down = 0;
            count_in = 4'h0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Count Up 3 cycles", test_num);
            reset_dut();
            @(negedge clk);
            up_down = 1;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Count Down 2 cycles (0 -> F -> E)", test_num);
            reset_dut();
            @(negedge clk);
            up_down = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Synchronous Load", test_num);
            reset_dut();
            @(negedge clk);
            count_in = 4'hA;
            load = 1;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Load 4'h7 then Count Up 2 cycles", test_num);
            reset_dut();
            @(negedge clk);
            count_in = 4'h7;
            load = 1;
            @(negedge clk);
            load = 0;
            up_down = 1;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Load 4'h2 then Count Down 3 cycles", test_num);
            reset_dut();
            @(negedge clk);
            count_in = 4'h2;
            load = 1;
            @(negedge clk);
            load = 0;
            up_down = 0;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Upward Overflow (F -> 0)", test_num);
            reset_dut();
            @(negedge clk);
            count_in = 4'hF;
            load = 1;
            @(negedge clk);
            load = 0;
            up_down = 1;
            @(negedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Reset Priority Check (Reset and Load active)", test_num);
            reset_dut();
            @(negedge clk);
            reset = 1;
            load = 1;
            count_in = 4'h5;
            @(negedge clk);
            reset = 0;
            load = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Load Priority Check (Load and Count active)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            count_in = 4'hB;
            up_down = 1;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(4'hB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, count_in, load, reset, up_down, count);
    end

endmodule
