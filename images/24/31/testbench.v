`timescale 1ns/1ps

module digital_phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] control;
    reg rst;
    wire phase_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    digital_phase_shifter dut (
        .clk(clk),
        .control(control),
        .rst(rst),
        .phase_out(phase_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            control = 3'b000;
            #20;
            @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            control = 3'b000;
            $display("Test %0d: Phase 0 (Control 000)", test_num);
            repeat(5) @(posedge clk);
            #3;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            control = 3'b001;
            $display("Test %0d: Phase 45 (Control 001)", test_num);
            repeat(5) @(posedge clk);
            #3;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            control = 3'b010;
            $display("Test %0d: Phase 90 (Control 010)", test_num);
            repeat(5) @(posedge clk);
            #3;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            control = 3'b011;
            $display("Test %0d: Phase 135 (Control 011)", test_num);
            repeat(5) @(posedge clk);
            #3;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            control = 3'b100;
            $display("Test %0d: Phase 180 (Control 100)", test_num);
            repeat(5) @(posedge clk);
            #3;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            control = 3'b101;
            $display("Test %0d: Phase 225 (Control 101)", test_num);
            repeat(5) @(posedge clk);
            #3;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            control = 3'b110;
            $display("Test %0d: Phase 270 (Control 110)", test_num);
            repeat(5) @(posedge clk);
            #3;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            control = 3'b111;
            $display("Test %0d: Phase 315 (Control 111)", test_num);
            repeat(5) @(posedge clk);
            #3;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("digital_phase_shifter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_phase_out;
        begin
            if (expected_phase_out === (expected_phase_out ^ phase_out ^ expected_phase_out)) begin
                $display("PASS");
                $display("  Outputs: phase_out=%b",
                         phase_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_out=%b",
                         expected_phase_out);
                $display("  Got:      phase_out=%b",
                         phase_out);
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
        $dumpvars(0,clk, control, rst, phase_out);
    end

endmodule
