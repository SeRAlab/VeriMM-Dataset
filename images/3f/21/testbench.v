`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] error;
    wire [3:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .error(error),
        .control_signal(control_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            error = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Zero Error", test_num);
            reset_dut();
            error = 4'sd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Small Positive Error (3)", test_num);
            reset_dut();
            error = 4'sd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'sd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Small Negative Error (-3)", test_num);
            reset_dut();
            error = -4'sd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-4'sd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Max Positive Error (7)", test_num);
            reset_dut();
            error = 4'sd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'sd7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Max Negative Error (-8)", test_num);
            reset_dut();
            error = -4'sd8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-4'sd8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Sequential Logic Check", test_num);
            reset_dut();

            error = 4'sd2;
            @(posedge clk);
            #1;

            error = -4'sd5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(-4'sd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deadbeat_controller Testbench");
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
        input [3:0] expected_control_signal;
        begin
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%h",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%h",
                         expected_control_signal);
                $display("  Got:      control_signal=%h",
                         control_signal);
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
        $dumpvars(0,clk, error, control_signal);
    end

endmodule
