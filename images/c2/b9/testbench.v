`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg clk;
    reg rst;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Simple positive addition (10 + 20)");
            reset_dut();
            a = 16'sd10;
            b = 16'sd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd30);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Simple negative addition (-15 + -25)");
            reset_dut();
            a = -16'sd15;
            b = -16'sd25;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-16'sd40);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Mixed signed addition (100 + -30)");
            reset_dut();
            a = 16'sd100;
            b = -16'sd30;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd70);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Mixed signed addition (-100 + 40)");
            reset_dut();
            a = -16'sd100;
            b = 16'sd40;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-16'sd60);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Adding zero (-500 + 0)");
            reset_dut();
            a = -16'sd500;
            b = 16'sd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-16'sd500);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Large positive values (15000 + 15000)");
            reset_dut();
            a = 16'sd15000;
            b = 16'sd15000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd30000);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Boundary negative addition (-32000 + 1000)");
            reset_dut();
            a = -16'sd32000;
            b = 16'sd1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-16'sd31000);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Verify Reset behavior");
            reset_dut();
            a = 16'sd500;
            b = 16'sd500;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd0);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
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
        input [15:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,a, b, clk, rst, sum);
    end

endmodule
