`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] setpoint;
    reg [7:0] y;
    wire [7:0] u;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .reset(reset),
        .setpoint(setpoint),
        .y(y),
        .u(u)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            setpoint = 0;
            y = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Positive Error Tracking");
            reset_dut();
            setpoint = 8'd100;
            y = 8'd30;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd70);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Zero Error");
            reset_dut();
            setpoint = 8'd150;
            y = 8'd150;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Negative Error Constraint");
            reset_dut();
            setpoint = 8'd50;
            y = 8'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Maximum Output Range");
            reset_dut();
            setpoint = 8'd255;
            y = 8'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Sequential Update Cycle");
            reset_dut();
            setpoint = 8'd80;
            y = 8'd20;
            @(posedge clk);
            #2;

            if (u !== 8'd60) begin
                $display("  Intermediate step failed. Got: %d", u);
            end


            setpoint = 8'd40;
            y = 8'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd30);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [7:0] expected_u;
        begin
            if (expected_u === (expected_u ^ u ^ expected_u)) begin
                $display("PASS");
                $display("  Outputs: u=%h",
                         u);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: u=%h",
                         expected_u);
                $display("  Got:      u=%h",
                         u);
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
        $dumpvars(0,clk, reset, setpoint, y, u);
    end

endmodule
