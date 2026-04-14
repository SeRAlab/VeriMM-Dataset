`timescale 1ns/1ps

module two_bit_output_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] b;
    reg clk;
    wire [1:0] so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    two_bit_output dut (
        .b(b),
        .clk(clk),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            b = 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            b = 4'd0;
            @(posedge clk);
            #1;
            $display("Testcase 001: Input b=0");
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            b = 4'd1;
            @(posedge clk);
            #1;
            $display("Testcase 002: Input b=1");
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            b = 4'd2;
            @(posedge clk);
            #1;
            $display("Testcase 003: Input b=2");
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            b = 4'd3;
            @(posedge clk);
            #1;
            $display("Testcase 004: Input b=3");
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            b = 4'd4;
            @(posedge clk);
            #1;
            $display("Testcase 005: Input b=4");
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            b = 4'd5;
            @(posedge clk);
            #1;
            $display("Testcase 006: Input b=5");
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            b = 4'd6;
            @(posedge clk);
            #1;
            $display("Testcase 007: Input b=6");
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            b = 4'd7;
            @(posedge clk);
            #1;
            $display("Testcase 008: Input b=7");
            #1;

            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("two_bit_output Testbench");
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
        input [1:0] expected_so;
        begin
            if (expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: so=%h",
                         so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: so=%h",
                         expected_so);
                $display("  Got:      so=%h",
                         so);
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
        $dumpvars(0,b, clk, so);
    end

endmodule
