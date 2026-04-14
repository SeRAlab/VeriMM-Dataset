`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [2:0] load_val;
    reg resetn;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .clk(clk),
        .load(load),
        .load_val(load_val),
        .resetn(resetn),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            load = 0;
            load_val = 0;
            #15;
            resetn = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Increment by 1", test_num);
            reset_dut();
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Increment by 5 cycles", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Synchronous Load", test_num);
            reset_dut();
            load = 1;
            load_val = 3'd6;
            @(posedge clk);
            #2;
            load = 0;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Load and Increment", test_num);
            reset_dut();
            load = 1;
            load_val = 3'd2;
            @(posedge clk);
            #2;
            load = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Wrap-around Check (Full Cycle)", test_num);
            reset_dut();
            repeat(8) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Load 7 and increment to 0", test_num);
            reset_dut();
            load = 1;
            load_val = 3'd7;
            @(posedge clk);
            #2;
            load = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Load priority over counting", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            load = 1;
            load_val = 3'd1;
            @(posedge clk);
            #2;
            load = 0;
            #1;

            check_outputs(3'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [2:0] expected_count;
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
        $dumpvars(0,clk, load, load_val, resetn, count);
    end

endmodule
