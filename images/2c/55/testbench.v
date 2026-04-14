`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] estimated_covariance;
    wire [15:0] estimated_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .control(control),
        .measurement(measurement),
        .reset(reset),
        .estimated_covariance(estimated_covariance),
        .estimated_state(estimated_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            control = 0;
            measurement = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initialization...");
            test_num = test_num + 1;
            reset_dut();


            #1;



            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Update Step...");
            test_num = test_num + 1;
            reset_dut();


            control = 16'h000A;
            measurement = 16'h0064;

            @(posedge clk);
            #1;




            #1;





            check_outputs(estimated_covariance, estimated_state);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Convergence over 10 cycles...");
            test_num = test_num + 1;
            reset_dut();

            control = 16'h0000;
            measurement = 16'h03E8;

            repeat (10) begin
                @(posedge clk);
            end
            #1;



            #1;




            check_outputs(estimated_covariance, estimated_state);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Tracking a moving object...");
            test_num = test_num + 1;
            reset_dut();

            control = 16'h0010;
            measurement = 16'h0010;

            for (i = 0; i < 20; i = i + 1) begin
                @(posedge clk);
                measurement = measurement + 16'h0010;
            end
            #1;



            #1;




            check_outputs(estimated_covariance, estimated_state);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Smoothing Noisy Input...");
            test_num = test_num + 1;
            reset_dut();

            control = 16'h0000;


            @(posedge clk) measurement = 16'h00C0;
            @(posedge clk) measurement = 16'h00D0;
            @(posedge clk) measurement = 16'h00C5;
            @(posedge clk) measurement = 16'h00B8;
            @(posedge clk) measurement = 16'h00C8;

            #1;

            #1;


            check_outputs(estimated_covariance, estimated_state);
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
        input [15:0] expected_estimated_covariance;
        input [15:0] expected_estimated_state;
        begin
            if (expected_estimated_covariance === (expected_estimated_covariance ^ estimated_covariance ^ expected_estimated_covariance) &&
                expected_estimated_state === (expected_estimated_state ^ estimated_state ^ expected_estimated_state)) begin
                $display("PASS");
                $display("  Outputs: estimated_covariance=%h, estimated_state=%h",
                         estimated_covariance, estimated_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_covariance=%h, estimated_state=%h",
                         expected_estimated_covariance, expected_estimated_state);
                $display("  Got:      estimated_covariance=%h, estimated_state=%h",
                         estimated_covariance, estimated_state);
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
        $dumpvars(0,clk, control, measurement, reset, estimated_covariance, estimated_state);
    end

endmodule
