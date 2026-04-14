`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] control;
    reg reset;
    wire [2:0] phase;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .clk(clk),
        .control(control),
        .reset(reset),
        .phase(phase)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Increment (Control=1)", test_num);
            reset_dut();
            control = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiple Accumulations", test_num);
            reset_dut();
            control = 3'b010;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Wrap-around Check", test_num);
            reset_dut();
            control = 3'b100;
            @(posedge clk);
            @(posedge clk);
            control = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Maximum Control Value (7)", test_num);
            reset_dut();
            control = 3'b111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Synchronous Reset Priority", test_num);
            reset_dut();
            control = 3'b011;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Control = 0 (No Shift)", test_num);
            reset_dut();
            control = 3'b010;
            @(posedge clk);
            control = 3'b000;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Complex Input Sequence", test_num);
            reset_dut();
            control = 3'b011;
            @(posedge clk);
            control = 3'b101;
            @(posedge clk);
            control = 3'b110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b110);
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
        input [2:0] expected_phase;
        begin
            if (expected_phase === (expected_phase ^ phase ^ expected_phase)) begin
                $display("PASS");
                $display("  Outputs: phase=%h",
                         phase);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase=%h",
                         expected_phase);
                $display("  Got:      phase=%h",
                         phase);
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
        $dumpvars(0,clk, control, reset, phase);
    end

endmodule
