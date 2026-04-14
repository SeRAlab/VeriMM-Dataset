`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] phase_in;
    reg rst;
    wire [4:0] phase_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .clk(clk),
        .phase_in(phase_in),
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
            phase_in = 5'b00000;
            @(negedge clk);
            rst = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit shift", test_num);
            reset_dut();
            phase_in = 5'b00001;
            @(negedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Double bit shift", test_num);
            reset_dut();
            phase_in = 5'b00001;
            @(negedge clk);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB to LSB wrap-around", test_num);
            reset_dut();
            phase_in = 5'b10000;
            @(negedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex pattern 3-cycle shift", test_num);
            reset_dut();
            phase_in = 5'b10101;
            @(negedge clk);
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b01101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full 5-cycle rotation check", test_num);
            reset_dut();
            phase_in = 5'b11000;
            @(negedge clk);
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11000);
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
        input [4:0] expected_phase_out;
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
        $dumpvars(0,clk, phase_in, rst, phase_out);
    end

endmodule
