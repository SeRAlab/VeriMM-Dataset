`timescale 1ns/1ps

module timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] max_count;
    reg reset;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer dut (
        .clk(clk),
        .max_count(max_count),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic counting up to 10");
            test_num = 1;
            max_count = 32'd20;
            reset_dut();

            repeat (10) @(posedge clk);
            #1 #1;
 check_outputs(32'd10);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking exact max_count reach");
            test_num = 2;
            max_count = 32'd5;
            reset_dut();

            repeat (5) @(posedge clk);
            #1 #1;
 check_outputs(32'd5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking wrap around to zero");
            test_num = 3;
            max_count = 32'd5;
            reset_dut();

            repeat (6) @(posedge clk);
            #1 #1;
 check_outputs(32'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking count after wrap around");
            test_num = 4;
            max_count = 32'd5;
            reset_dut();

            repeat (8) @(posedge clk);
            #1 #1;
 check_outputs(32'd2);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Boundary condition max_count = 0");
            test_num = 5;
            max_count = 32'd0;
            reset_dut();

            repeat (1) @(posedge clk);
            #1 #1;
 check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Testing large count value");
            test_num = 6;
            max_count = 32'hFFFF;
            reset_dut();
            repeat (1000) @(posedge clk);
            #1 #1;
 check_outputs(32'd1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer Testbench");
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
        input [31:0] expected_count;
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
        $dumpvars(0,clk, max_count, reset, count);
    end

endmodule
