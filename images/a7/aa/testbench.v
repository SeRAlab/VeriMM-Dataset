`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg up;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .down(down),
        .up(up),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            up = 0;
            down = 0;


            force dut.count = 4'h0;
            @(posedge clk);
            #1;
            release dut.count;
            $display("Resetting counter to 0...");
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Single increment", test_num);
            up = 1; down = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Multiple increments (0 to 5)", test_num);
            up = 1; down = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Single decrement from zero (underflow)", test_num);
            up = 0; down = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Counter overflow (0 to 16 steps)", test_num);
            up = 1; down = 0;
            repeat (16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Hold value when both up and down are high", test_num);

            up = 1; down = 0;
            repeat (3) @(posedge clk);

            up = 1; down = 1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Hold value when both up and down are low", test_num);

            up = 1; down = 0;
            repeat (7) @(posedge clk);

            up = 0; down = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Up 10 times, then Down 4 times", test_num);
            up = 1; down = 0;
            repeat (10) @(posedge clk);
            up = 0; down = 1;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: Complex sequence of operations", test_num);

            up = 1; down = 0; @(posedge clk);
            up = 1; down = 0; @(posedge clk);
            up = 0; down = 1; @(posedge clk);
            up = 1; down = 1; @(posedge clk);
            up = 0; down = 0; @(posedge clk);
            up = 0; down = 1; @(posedge clk);
            up = 0; down = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(4'hF);
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
        $dumpvars(0,clk, down, up, count);
    end

endmodule
