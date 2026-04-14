`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] estimated_position;
    reg [15:0] measured_position;
    reg reset;
    wire [15:0] new_estimated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .estimated_position(estimated_position),
        .measured_position(measured_position),
        .reset(reset),
        .new_estimated_position(new_estimated_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            estimated_position = 0;
            measured_position = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: System Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Steady State (Est=1000, Meas=1000)", test_num);
            reset_dut();
            estimated_position = 16'd1000;
            measured_position  = 16'd1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Fusion Update", test_num);
            reset_dut();
            estimated_position = 16'd2000;
            measured_position  = 16'd4000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd3000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Large Delta Change", test_num);
            reset_dut();
            estimated_position = 16'd0;
            measured_position  = 16'd10000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd5000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full Scale Range", test_num);
            reset_dut();
            estimated_position = 16'hFFFF;
            measured_position  = 16'hFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multi-cycle Convergence", test_num);
            reset_dut();


            estimated_position = 16'd0;
            measured_position  = 16'd100;
            @(posedge clk);
            #2;


            estimated_position = new_estimated_position;
            measured_position  = 16'd100;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'd75);
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
        input [15:0] expected_new_estimated_position;
        begin
            if (expected_new_estimated_position === (expected_new_estimated_position ^ new_estimated_position ^ expected_new_estimated_position)) begin
                $display("PASS");
                $display("  Outputs: new_estimated_position=%h",
                         new_estimated_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_estimated_position=%h",
                         expected_new_estimated_position);
                $display("  Got:      new_estimated_position=%h",
                         new_estimated_position);
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
        $dumpvars(0,clk, estimated_position, measured_position, reset, new_estimated_position);
    end

endmodule
