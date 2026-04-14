`timescale 1ns/1ps

module switching_regulator_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] load_current;
    reg rst;
    reg [7:0] v_in;
    wire pwm_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator_controller dut (
        .clk(clk),
        .load_current(load_current),
        .rst(rst),
        .v_in(v_in),
        .pwm_out(pwm_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            v_in = 0;
            load_current = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset state check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High V_IN (200), Low Load (10)", test_num);
            reset_dut();
            v_in = 8'd200;
            load_current = 8'd10;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Low V_IN (50), High Load (200)", test_num);
            reset_dut();
            v_in = 8'd50;
            load_current = 8'd200;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-range V_IN (128), Mid Load (128)", test_num);
            reset_dut();
            v_in = 8'd128;
            load_current = 8'd128;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum V_IN (255)", test_num);
            reset_dut();
            v_in = 8'd255;
            load_current = 8'd50;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Load Current (255)", test_num);
            reset_dut();
            v_in = 8'd100;
            load_current = 8'd255;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero V_IN", test_num);
            reset_dut();
            v_in = 8'd0;
            load_current = 8'd10;
            repeat(10) @(posedge clk);
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
        $display("switching_regulator_controller Testbench");
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
        input expected_pwm_out;
        begin
            if (expected_pwm_out === (expected_pwm_out ^ pwm_out ^ expected_pwm_out)) begin
                $display("PASS");
                $display("  Outputs: pwm_out=%b",
                         pwm_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm_out=%b",
                         expected_pwm_out);
                $display("  Got:      pwm_out=%b",
                         pwm_out);
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
        $dumpvars(0,clk, load_current, rst, v_in, pwm_out);
    end

endmodule
