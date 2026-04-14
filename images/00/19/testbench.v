`timescale 1ns/1ps

module counter16_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg enable;
    reg load;
    reg reset;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter16 dut (
        .clk(clk),
        .data(data),
        .enable(enable),
        .load(load),
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
            load = 0;
            enable = 0;
            data = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset check...");
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Simple incrementing...");
            reset_dut();
            enable = 1;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Enable/Hold check...");
            reset_dut();
            enable = 1;
            repeat (5) @(posedge clk);
            enable = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd5);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Load check...");
            reset_dut();
            enable = 1;
            data = 16'hA5A5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Load then increment...");
            reset_dut();
            enable = 1;
            data = 16'h1000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1005);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Roll over (0xFFFF -> 0x0000)...");
            reset_dut();
            enable = 1;
            data = 16'hFFFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Enable gated load...");
            reset_dut();

            enable = 0;
            data = 16'h1234;
            load = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Complex sequence...");
            reset_dut();
            enable = 1;
            repeat (3) @(posedge clk);
            data = 16'h8000;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat (2) @(posedge clk);
            enable = 0;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8002);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter16 Testbench");
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
        input [15:0] expected_count;
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
        $dumpvars(0,clk, data, enable, load, reset, count);
    end

endmodule
