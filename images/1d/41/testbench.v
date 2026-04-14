`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] current_state;
    reg [31:0] measurement;
    reg reset;
    reg [31:0] transition_matrix;
    wire [31:0] filtered_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .current_state(current_state),
        .measurement(measurement),
        .reset(reset),
        .transition_matrix(transition_matrix),
        .filtered_state(filtered_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_state = 0;
            measurement = 0;
            transition_matrix = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset State Verification", test_num);
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Identity Transition (Aligned State/Measurement)", test_num);
            reset_dut();
            current_state = 32'd100;
            measurement = 32'd100;
            transition_matrix = 32'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: State Prediction Scaling", test_num);
            reset_dut();
            current_state = 32'd50;
            measurement = 32'd100;
            transition_matrix = 32'd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Zero Transition Matrix", test_num);
            reset_dut();
            current_state = 32'd500;
            measurement = 32'd100;
            transition_matrix = 32'd0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Large Value Handling", test_num);
            reset_dut();
            current_state = 32'h0000FFFF;
            measurement = 32'h0000FFFF;
            transition_matrix = 32'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kalman_filter Testbench");
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
        input [31:0] expected_filtered_state;
        begin
            if (expected_filtered_state === (expected_filtered_state ^ filtered_state ^ expected_filtered_state)) begin
                $display("PASS");
                $display("  Outputs: filtered_state=%h",
                         filtered_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: filtered_state=%h",
                         expected_filtered_state);
                $display("  Got:      filtered_state=%h",
                         filtered_state);
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
        $dumpvars(0,clk, current_state, measurement, reset, transition_matrix, filtered_state);
    end

endmodule
