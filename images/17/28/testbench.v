`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] phase_in;
    reg reset;
    wire [2:0] phase_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .clk(clk),
        .phase_in(phase_in),
        .reset(reset),
        .phase_out(phase_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            phase_in = 3'b000;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: phase_in = 0");
            test_num = 1;
            reset_dut();
            phase_in = 3'b000;
            @(posedge clk);
            #2 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: phase_in = 1");
            test_num = 2;
            reset_dut();
            phase_in = 3'b001;
            @(posedge clk);
            #2 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: phase_in = 2");
            test_num = 3;
            reset_dut();
            phase_in = 3'b010;
            @(posedge clk);
            #2 #1;
 check_outputs(3'b011);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: phase_in = 3");
            test_num = 4;
            reset_dut();
            phase_in = 3'b011;
            @(posedge clk);
            #2 #1;
 check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: phase_in = 4");
            test_num = 5;
            reset_dut();
            phase_in = 3'b100;
            @(posedge clk);
            #2 #1;
 check_outputs(3'b101);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: phase_in = 5");
            test_num = 6;
            reset_dut();
            phase_in = 3'b101;
            @(posedge clk);
            #2 #1;
 check_outputs(3'b110);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: phase_in = 6");
            test_num = 7;
            reset_dut();
            phase_in = 3'b110;
            @(posedge clk);
            #2 #1;
 check_outputs(3'b111);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: phase_in = 7 (Wrap-around)");
            test_num = 8;
            reset_dut();
            phase_in = 3'b111;
            @(posedge clk);
            #2 #1;
 check_outputs(3'b000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_shifter Testbench");
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
        input [2:0] expected_phase_out;
        begin
            if (expected_phase_out === (expected_phase_out ^ phase_out ^ expected_phase_out)) begin
                $display("PASS");
                $display("  Outputs: phase_out=%h",
                         phase_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_out=%h",
                         expected_phase_out);
                $display("  Got:      phase_out=%h",
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
        $dumpvars(0,clk, phase_in, reset, phase_out);
    end

endmodule
