`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] reference;
    reg reset;
    reg [7:0] state;
    wire [7:0] control_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .reference(reference),
        .reset(reset),
        .state(state),
        .control_out(control_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            reference = 0;
            state = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial state after reset", test_num);
            reset_dut();

            reference = 8'd50;
            state = 8'd10;



            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Proportional control with stored state", test_num);
            reset_dut();


            reference = 8'd100;
            state = 8'd30;
            @(posedge clk);
            #1;



            reference = 8'd100;
            state = 8'd60;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd70);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High state value tracking", test_num);
            reset_dut();

            state = 8'd200;
            @(posedge clk);
            #1;

            reference = 8'd250;
            state = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero error control output", test_num);
            reset_dut();

            state = 8'd120;
            @(posedge clk);
            #1;

            reference = 8'd120;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Step change in reference signal", test_num);
            reset_dut();

            state = 8'd50;
            reference = 8'd100;
            @(posedge clk);
            #1;


            reference = 8'd150;
            state = 8'd50;
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
        input [7:0] expected_control_out;
        begin
            if (expected_control_out === (expected_control_out ^ control_out ^ expected_control_out)) begin
                $display("PASS");
                $display("  Outputs: control_out=%h",
                         control_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_out=%h",
                         expected_control_out);
                $display("  Got:      control_out=%h",
                         control_out);
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
        $dumpvars(0,clk, reference, reset, state, control_out);
    end

endmodule
