`timescale 1ns/1ps

module garage_door_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg close;
    reg open;
    reg resetn;
    wire door_open;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    garage_door dut (
        .clk(clk),
        .close(close),
        .open(open),
        .resetn(resetn),
        .door_open(door_open)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            open = 0;
            close = 0;
            @(posedge clk);
            #1;
            resetn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Open Door Transition", test_num);
            reset_dut();
            open = 1;
            @(posedge clk);
            #1 open = 0;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Open then Close Door", test_num);
            reset_dut();

            open = 1;
            @(posedge clk);
            #1 open = 0;
            repeat(2) @(posedge clk);

            #1 close = 1;
            @(posedge clk);
            #1 close = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Close Door when already closed", test_num);
            reset_dut();
            close = 1;
            @(posedge clk);
            #1 close = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Open Door when already open", test_num);
            reset_dut();

            open = 1;
            @(posedge clk);
            #1 open = 0;
            repeat(2) @(posedge clk);

            #1 open = 1;
            @(posedge clk);
            #1 open = 0;
            repeat(2) @(posedge clk);
            #1;
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
        $display("garage_door Testbench");
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
        input expected_door_open;
        begin
            if (expected_door_open === (expected_door_open ^ door_open ^ expected_door_open)) begin
                $display("PASS");
                $display("  Outputs: door_open=%b",
                         door_open);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: door_open=%b",
                         expected_door_open);
                $display("  Got:      door_open=%b",
                         door_open);
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
        $dumpvars(0,clk, close, open, resetn, door_open);
    end

endmodule
