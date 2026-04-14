`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [1:0] speed_input;
    wire [1:0] speed_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
        .clk(clk),
        .rst(rst),
        .speed_input(speed_input),
        .speed_output(speed_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            speed_input = 2'b00;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset condition (OFF state)", test_num);
            reset_dut();
            #5;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition to LOW", test_num);
            reset_dut();
            @(posedge clk);
            speed_input = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition to MEDIUM", test_num);
            reset_dut();
            @(posedge clk);
            speed_input = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition to HIGH", test_num);
            reset_dut();
            @(posedge clk);
            speed_input = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maintain state (Stay LOW)", test_num);
            reset_dut();
            @(posedge clk);
            speed_input = 2'b01;
            @(posedge clk);



            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential transition LOW to HIGH", test_num);
            reset_dut();
            @(posedge clk);
            speed_input = 2'b01;
            @(posedge clk);
            speed_input = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition HIGH to MEDIUM to OFF", test_num);
            reset_dut();
            @(posedge clk);
            speed_input = 2'b11;
            @(posedge clk);
            speed_input = 2'b10;
            @(posedge clk);
            speed_input = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rapid input changes to MEDIUM", test_num);
            reset_dut();
            @(posedge clk);
            speed_input = 2'b01;
            #2 speed_input = 2'b11;
            #2 speed_input = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fan_speed_control Testbench");
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
        input [1:0] expected_speed_output;
        begin
            if (expected_speed_output === (expected_speed_output ^ speed_output ^ expected_speed_output)) begin
                $display("PASS");
                $display("  Outputs: speed_output=%h",
                         speed_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: speed_output=%h",
                         expected_speed_output);
                $display("  Got:      speed_output=%h",
                         speed_output);
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
        $dumpvars(0,clk, rst, speed_input, speed_output);
    end

endmodule
