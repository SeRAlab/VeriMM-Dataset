`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] ref_input;
    reg rst;
    reg [7:0] state_input;
    wire [7:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .ref_input(ref_input),
        .rst(rst),
        .state_input(state_input),
        .output_signal(output_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ref_input = 0;
            state_input = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Positive Error Accumulation", test_num);
            reset_dut();
            ref_input = 8'd10;
            state_input = 8'd8;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Zero Error", test_num);
            reset_dut();
            ref_input = 8'd50;
            state_input = 8'd50;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Negative Error Accumulation", test_num);
            reset_dut();
            ref_input = 8'd10;
            state_input = 8'd15;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'hF6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Large Error Accumulation", test_num);
            reset_dut();
            ref_input = 8'd100;
            state_input = 8'd50;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(8'd150);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Dynamic Input Tracking", test_num);
            reset_dut();


            ref_input = 8'd20;
            state_input = 8'd10;
            repeat(2) @(posedge clk);


            ref_input = 8'd10;
            state_input = 8'd15;
            repeat(2) @(posedge clk);

            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Small Positive Delta at High Reference", test_num);
            reset_dut();
            ref_input = 8'hFF;
            state_input = 8'hFE;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_controller Testbench");
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
        input [7:0] expected_output_signal;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, ref_input, rst, state_input, output_signal);
    end

endmodule
