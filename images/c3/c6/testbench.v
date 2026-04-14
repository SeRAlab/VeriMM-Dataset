`timescale 1ns/1ps

module MAC_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg clk;
    reg sof;
    wire [35:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MAC dut (
        .A(A),
        .B(B),
        .clk(clk),
        .sof(sof),
        .C(C)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            sof = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Basic MAC operation (10 * 5)");
            reset_dut();
            A = 16'd10;
            B = 16'd5;
            sof = 1;
            @(posedge clk);
            #1;
            sof = 0;
            expected_val = expected_val + (16'd10 * 16'd5);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Multi-cycle accumulation");
            reset_dut();

            A = 16'd2;
            B = 16'd3;
            sof = 1;
            @(posedge clk);
            #1;
            expected_val = expected_val + (16'd2 * 16'd3);


            A = 16'd100;
            B = 16'd4;
            sof = 1;
            @(posedge clk);
            #1;
            expected_val = expected_val + (16'd100 * 16'd4);

            sof = 0;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: SOF Enable check (SOF=0 should not update)");
            reset_dut();

            A = 16'd50;
            B = 16'd50;
            sof = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(expected_val);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Large value multiplication");
            reset_dut();
            A = 16'hFFFF;
            B = 16'h0002;
            sof = 1;
            @(posedge clk);
            #1;
            sof = 0;
            expected_val = expected_val + (16'hFFFF * 16'h0002);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Multiplication by zero");
            reset_dut();
            A = 16'd1234;
            B = 16'd0;
            sof = 1;
            @(posedge clk);
            #1;
            sof = 0;
            expected_val = expected_val + (16'd1234 * 16'd0);
            #1;

            check_outputs(expected_val);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MAC Testbench");
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
        input [35:0] expected_C;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
        $dumpvars(0,A, B, clk, sof, C);
    end

endmodule
