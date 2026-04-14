`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg reset;
    reg update;
    wire [15:0] estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .reset(reset),
        .update(update),
        .estimate(estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measurement = 0;
            update = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset and First Update", test_num);
            reset_dut();

            measurement = 16'h2000;
            update = 1;
            @(posedge clk);
            update = 0;
            @(posedge clk);





            if (estimate > 16'h0000 && estimate <= 16'h2000)
                #1;

                check_outputs(estimate);
            else
                #1;

                check_outputs(16'h2000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Convergence to Constant Input", test_num);
            reset_dut();

            measurement = 16'h4000;
            for (i = 0; i < 20; i = i + 1) begin
                update = 1;
                @(posedge clk);
                update = 0;
                repeat(2) @(posedge clk);
            end



            if (estimate >= 16'h3F00 && estimate <= 16'h4100)
                #1;

                check_outputs(estimate);
            else
                #1;

                check_outputs(16'h4000);
        end
        endtask

    task testcase003;

        reg [15:0] first_estimate;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Update Signal Sensitivity", test_num);
            reset_dut();


            measurement = 16'h1000;
            update = 1;
            @(posedge clk);
            update = 0;
            @(posedge clk);
            first_estimate = estimate;


            measurement = 16'h7000;
            repeat(10) @(posedge clk);


            #1;



            check_outputs(first_estimate);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Noise Filtering Behavior", test_num);
            reset_dut();


            repeat(5) begin
                measurement = 16'h2E00; update = 1; @(posedge clk); update = 0; repeat(2) @(posedge clk);
                measurement = 16'h3200; update = 1; @(posedge clk); update = 0; repeat(2) @(posedge clk);
            end


            if (estimate > 16'h2F00 && estimate < 16'h3100)
                #1;

                check_outputs(estimate);
            else
                #1;

                check_outputs(16'h3000);
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
        input [15:0] expected_estimate;
        begin
            if (expected_estimate === (expected_estimate ^ estimate ^ expected_estimate)) begin
                $display("PASS");
                $display("  Outputs: estimate=%h",
                         estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimate=%h",
                         expected_estimate);
                $display("  Got:      estimate=%h",
                         estimate);
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
        $dumpvars(0,clk, measurement, reset, update, estimate);
    end

endmodule
