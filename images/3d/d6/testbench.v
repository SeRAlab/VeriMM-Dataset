`timescale 1ns/1ps

module monte_carlo_pi_tb;

    // Testbench signals (sequential circuit)
    reg valid;
    reg [7:0] x;
    reg [7:0] y;
    wire [15:0] pi_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_pi dut (
        .valid(valid),
        .x(x),
        .y(y),
        .pi_estimate(pi_estimate)
    );

    // Clock generation (10ns period)
    initial begin
        valid = 0;
        forever #5 valid = ~valid;
    end

        task reset_dut;

        begin
            rst_n = 0;
            x = 0;
            y = 0;
            repeat(2) @(negedge valid);
            rst_n = 1;
            @(negedge valid);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All points inside circle (Expected Pi = 4.0)", test_num);
            reset_dut();


            x = 8'd0;   y = 8'd0;   @(negedge valid);

            x = 8'd100; y = 8'd100; @(negedge valid);

            x = 8'd180; y = 8'd180; @(negedge valid);

            x = 8'd50;  y = 8'd200; @(negedge valid);

            #1;


            check_outputs(16'd40000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All points outside circle (Expected Pi = 0.0)", test_num);
            reset_dut();


            x = 8'd255; y = 8'd255; @(negedge valid);

            x = 8'd200; y = 8'd200; @(negedge valid);

            x = 8'd182; y = 8'd182; @(negedge valid);

            x = 8'd255; y = 8'd10;  @(negedge valid);

            #1;


            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: 50%% hit rate (Expected Pi = 2.0)", test_num);
            reset_dut();

            x = 8'd0;   y = 8'd0;   @(negedge valid);
            x = 8'd255; y = 8'd255; @(negedge valid);
            x = 8'd100; y = 8'd100; @(negedge valid);
            x = 8'd200; y = 8'd200; @(negedge valid);

            #1;


            check_outputs(16'd20000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: 75%% hit rate (Expected Pi = 3.0)", test_num);
            reset_dut();

            x = 8'd10;  y = 8'd10;  @(negedge valid);
            x = 8'd100; y = 8'd100; @(negedge valid);
            x = 8'd20;  y = 8'd20;  @(negedge valid);
            x = 8'd250; y = 8'd250; @(negedge valid);

            #1;


            check_outputs(16'd30000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("monte_carlo_pi Testbench");
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
        input [15:0] expected_pi_estimate;
        begin
            if (expected_pi_estimate === (expected_pi_estimate ^ pi_estimate ^ expected_pi_estimate)) begin
                $display("PASS");
                $display("  Outputs: pi_estimate=%h",
                         pi_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pi_estimate=%h",
                         expected_pi_estimate);
                $display("  Got:      pi_estimate=%h",
                         pi_estimate);
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
        $dumpvars(0,valid, x, y, pi_estimate);
    end

endmodule
