`timescale 1ns/1ps

module butterworth_filter_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [4:0] input_signal;
    wire [4:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    butterworth_filter dut (
        .clk(clk),
        .input_signal(input_signal),
        .output_signal(output_signal)
    );
    task reset_filter;

    begin
        input_signal = 5'd0;
        repeat(20) @(posedge clk);
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Zero Input Response", test_num);
        reset_filter();

        input_signal = 5'd0;
        repeat(10) @(posedge clk);

        #1;


        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mid-scale DC Step Response", test_num);
        reset_filter();

        input_signal = 5'd16;
        repeat(30) @(posedge clk);

        #1;


        check_outputs(5'd16);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Full-scale DC Step Response", test_num);
        reset_filter();

        input_signal = 5'd31;
        repeat(30) @(posedge clk);

        #1;


        check_outputs(5'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: High-Frequency Attenuation", test_num);
        reset_filter();

        repeat(20) begin
            input_signal = 5'd0;
            @(posedge clk);
            input_signal = 5'd30;
            @(posedge clk);
        end



        #1;




        check_outputs(5'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Small Signal Step Response", test_num);
        reset_filter();

        input_signal = 5'd4;
        repeat(20) @(posedge clk);

        #1;


        check_outputs(5'd4);
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
        input [4:0] expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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

endmodule
