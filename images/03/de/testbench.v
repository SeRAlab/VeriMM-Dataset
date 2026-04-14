`timescale 1ns/1ps

module butterworth_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] current_input;
    wire [4:0] filtered_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    butterworth_filter dut (
        .clk(clk),
        .current_input(current_input),
        .filtered_output(filtered_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        current_input = 5'd0;

        @(posedge clk);
        #1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Steady state zero", test_num);
        reset_dut();
        current_input = 5'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Step response 0 to 20", test_num);
        reset_dut();
        current_input = 5'd20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Averaging 10 and 20", test_num);
        reset_dut();
        current_input = 5'd10;
        @(posedge clk);
        #1;
        current_input = 5'd20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum 5-bit values (31)", test_num);
        reset_dut();
        current_input = 5'd31;
        @(posedge clk);
        #1;
        current_input = 5'd31;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Truncation check (10 + 11)/2", test_num);
        reset_dut();
        current_input = 5'd10;
        @(posedge clk);
        #1;
        current_input = 5'd11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Falling step (30 to 10)", test_num);
        reset_dut();
        current_input = 5'd30;
        @(posedge clk);
        #1;
        current_input = 5'd10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd20);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("butterworth_filter Testbench");
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
        input [4:0] expected_filtered_output;
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
        $dumpvars(0,clk, current_input, filtered_output);
    end

endmodule
