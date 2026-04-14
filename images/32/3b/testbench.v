`timescale 1ns/1ps

module cordic_vectoring_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x_input;
    reg [15:0] y_input;
    wire [15:0] angle_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cordic_vectoring dut (
        .clk(clk),
        .rst(rst),
        .x_input(x_input),
        .y_input(y_input),
        .angle_output(angle_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x_input = 0;
            y_input = 0;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Input (x=4000, y=0) - Expecting Angle 0", test_num);
            x_input = 16'h0FA0;
            y_input = 16'h0000;
            #200;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Input (x=4000, y=4000) - Expecting Angle pi/4", test_num);
            x_input = 16'h0FA0;
            y_input = 16'h0FA0;
            #200;
            #1;

            check_outputs(16'h1922);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Input (x=0, y=4000) - Expecting Angle pi/2", test_num);
            x_input = 16'h0000;
            y_input = 16'h0FA0;
            #200;
            #1;

            check_outputs(16'h3244);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Input (x=-4000, y=4000) - Expecting Angle 3pi/4", test_num);
            x_input = 16'hF060;
            y_input = 16'h0FA0;
            #200;
            #1;

            check_outputs(16'h4B66);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Input (x=4000, y=-4000) - Expecting Angle -pi/4", test_num);
            x_input = 16'h0FA0;
            y_input = 16'hF060;
            #200;
            #1;

            check_outputs(16'hE6DE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Input (x=0, y=-4000) - Expecting Angle -pi/2", test_num);
            x_input = 16'h0000;
            y_input = 16'hF060;
            #200;
            #1;

            check_outputs(16'hCDBC);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Input (x=-4000, y=-4000) - Expecting Angle -3pi/4", test_num);
            x_input = 16'hF060;
            y_input = 16'hF060;
            #200;
            #1;

            check_outputs(16'hB49A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cordic_vectoring Testbench");
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
        input [15:0] expected_angle_output;
        begin
            if (expected_angle_output === (expected_angle_output ^ angle_output ^ expected_angle_output)) begin
                $display("PASS");
                $display("  Outputs: angle_output=%h",
                         angle_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: angle_output=%h",
                         expected_angle_output);
                $display("  Got:      angle_output=%h",
                         angle_output);
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
        $dumpvars(0,clk, rst, x_input, y_input, angle_output);
    end

endmodule
