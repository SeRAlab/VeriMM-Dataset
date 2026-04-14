`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] pred_cov;
    reg [15:0] pred_state;
    reg rst;
    reg [15:0] sensor1;
    reg [15:0] sensor2;
    wire [15:0] updated_cov;
    wire [15:0] updated_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .pred_cov(pred_cov),
        .pred_state(pred_state),
        .rst(rst),
        .sensor1(sensor1),
        .sensor2(sensor2),
        .updated_cov(updated_cov),
        .updated_state(updated_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pred_cov = 0;
            pred_state = 0;
            sensor1 = 0;
            sensor2 = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equilibrium State", test_num);


            pred_state = 16'h1000;
            pred_cov   = 16'h0100;
            sensor1    = 16'h1000;
            sensor2    = 16'h1000;

            repeat(2) @(posedge clk);




            #1;





            check_outputs(16'h0080, 16'h1000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Prediction Uncertainty", test_num);

            pred_state = 16'h0000;
            pred_cov   = 16'hFF00;
            sensor1    = 16'h2000;
            sensor2    = 16'h2000;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(16'h00FE, 16'h1FF0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Low Prediction Uncertainty", test_num);

            pred_state = 16'h4000;
            pred_cov   = 16'h0001;
            sensor1    = 16'h0000;
            sensor2    = 16'h0000;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(16'h0001, 16'h3FFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sensor Fusion Averaging", test_num);

            pred_state = 16'h1000;
            pred_cov   = 16'h0400;
            sensor1    = 16'h2000;
            sensor2    = 16'h0000;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(16'h0200, 16'h1000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Inputs", test_num);

            pred_state = 16'h0000;
            pred_cov   = 16'h0000;
            sensor1    = 16'h0000;
            sensor2    = 16'h0000;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'h0000, 16'h0000);
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
        input [15:0] expected_updated_cov;
        input [15:0] expected_updated_state;
        begin
            if (expected_updated_cov === (expected_updated_cov ^ updated_cov ^ expected_updated_cov) &&
                expected_updated_state === (expected_updated_state ^ updated_state ^ expected_updated_state)) begin
                $display("PASS");
                $display("  Outputs: updated_cov=%h, updated_state=%h",
                         updated_cov, updated_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_cov=%h, updated_state=%h",
                         expected_updated_cov, expected_updated_state);
                $display("  Got:      updated_cov=%h, updated_state=%h",
                         updated_cov, updated_state);
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
        $dumpvars(0,clk, pred_cov, pred_state, rst, sensor1, sensor2, updated_cov, updated_state);
    end

endmodule
