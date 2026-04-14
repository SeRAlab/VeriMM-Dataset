`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] filtered_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .reset(reset),
        .filtered_output(filtered_output)
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
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Steady state convergence (low value)", test_num);
            reset_dut();
            measurement = 16'h0064;


            repeat (50) @(posedge clk);


            #1;



            check_outputs(16'h0064);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Steady state convergence (high value)", test_num);
            reset_dut();
            measurement = 16'h7FFF;

            repeat (50) @(posedge clk);

            #1;


            check_outputs(16'h7FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Zero input test", test_num);
            reset_dut();
            measurement = 16'h0000;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Step response tracking", test_num);
            reset_dut();


            measurement = 16'd1000;
            repeat (30) @(posedge clk);


            measurement = 16'd2000;
            repeat (50) @(posedge clk);

            #1;


            check_outputs(16'd2000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: High frequency noise filtering", test_num);
            reset_dut();



            for (i = 0; i < 40; i = i + 1) begin
                if (i % 2 == 0)
                    measurement = 16'd490;
                else
                    measurement = 16'd510;
                @(posedge clk);
            end


            #1;



            check_outputs(16'd500);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Maximum range test", test_num);
            reset_dut();
            measurement = 16'hFFFF;

            repeat (50) @(posedge clk);

            #1;


            check_outputs(16'hFFFF);
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
        input [15:0] expected_filtered_output;
        begin
            if (expected_filtered_output === (expected_filtered_output ^ filtered_output ^ expected_filtered_output)) begin
                $display("PASS");
                $display("  Outputs: filtered_output=%h",
                         filtered_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: filtered_output=%h",
                         expected_filtered_output);
                $display("  Got:      filtered_output=%h",
                         filtered_output);
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
        $dumpvars(0,clk, measurement, reset, filtered_output);
    end

endmodule
