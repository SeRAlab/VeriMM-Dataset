`timescale 1ns/1ps

module verified_up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg rst;
    reg up;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    verified_up_down_counter dut (
        .clk(clk),
        .down(down),
        .rst(rst),
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
            rst = 1;
            up = 0;
            down = 0;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Simple Increment (Count to 3)");
            reset_dut();
            up = 1;
            down = 0;
            repeat(3) @(posedge clk);
            up = 0;
            #1 #1;
 check_outputs(3'b011);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Simple Decrement (Count to -2 -> 6)");
            reset_dut();
            up = 0;
            down = 1;
            repeat(2) @(posedge clk);
            down = 0;
            #1 #1;
 check_outputs(3'b110);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Hold State (up=0, down=0)");
            reset_dut();
            up = 1;
            @(posedge clk);
            up = 0;
            down = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Hold State (up=1, down=1)");
            reset_dut();
            up = 1;
            repeat(2) @(posedge clk);
            up = 1;
            down = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Rollover Check");
            reset_dut();
            up = 1;
            repeat(8) @(posedge clk);
            up = 0;
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Roll-under Check");
            reset_dut();
            down = 1;
            @(posedge clk);
            down = 0;
            #1 #1;
 check_outputs(3'b111);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Up 5, Down 2 Sequence");
            reset_dut();
            up = 1;
            repeat(5) @(posedge clk);
            up = 0;
            down = 1;
            repeat(2) @(posedge clk);
            down = 0;
            #1 #1;
 check_outputs(3'b011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("verified_up_down_counter Testbench");
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
        $dumpvars(0,clk, down, rst, up, count);
    end

endmodule
