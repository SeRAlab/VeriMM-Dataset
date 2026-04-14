`timescale 1ns/1ps

module temp_sensor_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] temp_input;
    wire safe_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_sensor_controller dut (
        .clk(clk),
        .rst(rst),
        .temp_input(temp_input),
        .safe_temp(safe_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            temp_input = 4'd0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Temperature = 0 (Expected: Unsafe/0)", test_num);
            reset_dut();
            temp_input = 4'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Temperature = 1 (Expected: Safe/1)", test_num);
            reset_dut();
            temp_input = 4'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Temperature = 5 (Expected: Safe/1)", test_num);
            reset_dut();
            temp_input = 4'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Temperature = 10 (Expected: Safe/1)", test_num);
            reset_dut();
            temp_input = 4'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Temperature = 11 (Expected: Unsafe/0)", test_num);
            reset_dut();
            temp_input = 4'd11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Temperature = 15 (Expected: Unsafe/0)", test_num);
            reset_dut();
            temp_input = 4'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Testing Reset logic during active safe temp", test_num);
            reset_dut();
            temp_input = 4'd7;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
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
        $display("temp_sensor_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_safe_temp;
        begin
            if (expected_safe_temp === (expected_safe_temp ^ safe_temp ^ expected_safe_temp)) begin
                $display("PASS");
                $display("  Outputs: safe_temp=%b",
                         safe_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: safe_temp=%b",
                         expected_safe_temp);
                $display("  Got:      safe_temp=%b",
                         safe_temp);
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
        $dumpvars(0,clk, rst, temp_input, safe_temp);
    end

endmodule
