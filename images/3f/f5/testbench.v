`timescale 1ns/1ps

module monte_carlo_pi_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] random_x;
    reg [15:0] random_y;
    reg start;
    wire finished;
    wire [31:0] pi_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_pi dut (
        .clk(clk),
        .random_x(random_x),
        .random_y(random_y),
        .start(start),
        .finished(finished),
        .pi_estimate(pi_estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            random_x = 16'h0;
            random_y = 16'h0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: All points inside (Origin)", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;

            while (!finished) begin
                random_x = 16'sd0;
                random_y = 16'sd0;
                @(posedge clk);
            end
            #1;

            check_outputs(1'b1, 32'h00040000);
            start = 0;
            repeat (2) @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: All points outside (Corners)", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            while (!finished) begin
                random_x = 16'h7FFF;
                random_y = 16'h7FFF;
                @(posedge clk);
            end
            #1;

            check_outputs(1'b1, 32'h00000000);
            start = 0;
            repeat (2) @(posedge clk);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: 50%% points inside", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            i = 0;
            while (!finished) begin
                if (i % 2 == 0) begin
                    random_x = 16'sd0; random_y = 16'sd0;
                end else begin
                    random_x = 16'h7FFF; random_y = 16'h7FFF;
                end
                i = i + 1;
                @(posedge clk);
            end
            #1;

            check_outputs(1'b1, 32'h00020000);
            start = 0;
            repeat (2) @(posedge clk);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: 75%% points inside", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            i = 0;
            while (!finished) begin
                if (i % 4 != 0) begin
                    random_x = 16'sd0; random_y = 16'sd0;
                end else begin
                    random_x = 16'h7FFF; random_y = 16'h7FFF;
                end
                i = i + 1;
                @(posedge clk);
            end
            #1;

            check_outputs(1'b1, 32'h00030000);
            start = 0;
            repeat (2) @(posedge clk);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: 25%% points inside", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            i = 0;
            while (!finished) begin
                if (i % 4 == 0) begin
                    random_x = 16'sd0; random_y = 16'sd0;
                end else begin
                    random_x = 16'h7FFF; random_y = 16'h7FFF;
                end
                i = i + 1;
                @(posedge clk);
            end
            #1;

            check_outputs(1'b1, 32'h00010000);
            start = 0;
            repeat (2) @(posedge clk);
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
        input expected_finished;
        input [31:0] expected_pi_estimate;
        begin
            if (expected_finished === (expected_finished ^ finished ^ expected_finished) &&
                expected_pi_estimate === (expected_pi_estimate ^ pi_estimate ^ expected_pi_estimate)) begin
                $display("PASS");
                $display("  Outputs: finished=%b, pi_estimate=%h",
                         finished, pi_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: finished=%b, pi_estimate=%h",
                         expected_finished, expected_pi_estimate);
                $display("  Got:      finished=%b, pi_estimate=%h",
                         finished, pi_estimate);
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
        $dumpvars(0,clk, random_x, random_y, start, finished, pi_estimate);
    end

endmodule
