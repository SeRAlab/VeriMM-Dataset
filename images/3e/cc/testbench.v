`timescale 1ns/1ps

module temperature_monitor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_temp;
    reg reset;
    wire [7:0] avg_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_monitor dut (
        .clk(clk),
        .current_temp(current_temp),
        .reset(reset),
        .avg_temp(avg_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_temp = 0;
            repeat (2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Constant Temperature", test_num);
            reset_dut();

            repeat (5) begin
                @(posedge clk);
                current_temp = 8'd100;
            end

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Linear Ramp", test_num);
            reset_dut();

            @(posedge clk); current_temp = 8'd10;
            @(posedge clk); current_temp = 8'd20;
            @(posedge clk); current_temp = 8'd30;
            @(posedge clk); current_temp = 8'd40;
            @(posedge clk); current_temp = 8'd50;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Maximum Values", test_num);
            reset_dut();

            repeat (5) begin
                @(posedge clk);
                current_temp = 8'd255;
            end

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Truncation Check", test_num);
            reset_dut();

            @(posedge clk); current_temp = 8'd11;
            @(posedge clk); current_temp = 8'd11;
            @(posedge clk); current_temp = 8'd11;
            @(posedge clk); current_temp = 8'd11;
            @(posedge clk); current_temp = 8'd12;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Moving Window Check", test_num);
            reset_dut();

            @(posedge clk); current_temp = 8'd200;
            @(posedge clk); current_temp = 8'd10;
            @(posedge clk); current_temp = 8'd10;
            @(posedge clk); current_temp = 8'd10;
            @(posedge clk); current_temp = 8'd10;
            @(posedge clk); current_temp = 8'd10;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Random Variations", test_num);
            reset_dut();

            @(posedge clk); current_temp = 8'd100;
            @(posedge clk); current_temp = 8'd50;
            @(posedge clk); current_temp = 8'd150;
            @(posedge clk); current_temp = 8'd200;
            @(posedge clk); current_temp = 8'd0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_monitor Testbench");
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
        input [7:0] expected_avg_temp;
        begin
            if (expected_avg_temp === (expected_avg_temp ^ avg_temp ^ expected_avg_temp)) begin
                $display("PASS");
                $display("  Outputs: avg_temp=%h",
                         avg_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avg_temp=%h",
                         expected_avg_temp);
                $display("  Got:      avg_temp=%h",
                         avg_temp);
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
        $dumpvars(0,clk, current_temp, reset, avg_temp);
    end

endmodule
