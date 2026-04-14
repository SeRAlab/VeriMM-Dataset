`timescale 1ns/1ps

module phase_frequency_detector_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg clk;
    wire DOWN;
    wire UP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_frequency_detector dut (
        .A(A),
        .B(B),
        .clk(clk),
        .DOWN(DOWN),
        .UP(UP)
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

            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Idle State");
            test_num = test_num + 1;
            reset_dut();

            A = 0;
            B = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Clock A leads Clock B");
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            A = 1; B = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Clock B leads Clock A");
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            A = 0; B = 1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: A Frequency > B Frequency");
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk) A = 1; B = 0;
            @(posedge clk) A = 0; B = 0;
            @(posedge clk) A = 1; B = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: B Frequency > A Frequency");
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk) A = 0; B = 1;
            @(posedge clk) A = 0; B = 0;
            @(posedge clk) A = 0; B = 1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Signals in phase");
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            A = 1; B = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_frequency_detector Testbench");
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
        input expected_DOWN;
        input expected_UP;
        begin
            if (expected_DOWN === (expected_DOWN ^ DOWN ^ expected_DOWN) &&
                expected_UP === (expected_UP ^ UP ^ expected_UP)) begin
                $display("PASS");
                $display("  Outputs: DOWN=%b, UP=%b",
                         DOWN, UP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOWN=%b, UP=%b",
                         expected_DOWN, expected_UP);
                $display("  Got:      DOWN=%b, UP=%b",
                         DOWN, UP);
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
        $dumpvars(0,A, B, clk, DOWN, UP);
    end

endmodule
