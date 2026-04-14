`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_output;
    reg [3:0] reference;
    reg rst;
    wire [3:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .current_output(current_output),
        .reference(reference),
        .rst(rst),
        .control_signal(control_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            current_output = 0;
            reference = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            current_output = 4'd0;
            reference = 4'd5;


            @(posedge clk);
            #1 #1;
 check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            current_output = 4'd10;
            reference = 4'd10;

            @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            current_output = 4'd12;
            reference = 4'd4;

            @(posedge clk);
            #1 #1;
 check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            current_output = 4'd0;
            reference = 4'd15;

            @(posedge clk);
            #1 #1;
 check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            current_output = 4'd15;
            reference = 4'd0;

            @(posedge clk);
            #1 #1;
 check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            current_output = 4'd7;
            reference = 4'd8;

            @(posedge clk);
            #1 #1;
 check_outputs(4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deadbeat_controller Testbench");
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
        input [3:0] expected_control_signal;
        begin
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%h",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%h",
                         expected_control_signal);
                $display("  Got:      control_signal=%h",
                         control_signal);
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
        $dumpvars(0,clk, current_output, reference, rst, control_signal);
    end

endmodule
