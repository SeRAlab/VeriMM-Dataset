`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg clk;
    wire out_inphase;
    wire out_lag;
    wire out_lead;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .A(A),
        .B(B),
        .clk(clk),
        .out_inphase(out_inphase),
        .out_lag(out_lag),
        .out_lead(out_lead)
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
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: In-phase");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            A <= 1;
            B <= 1;


            repeat (2) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: A Leads B");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            A <= 1;
            B <= 0;

            @(posedge clk);
            B <= 1;

            repeat (2) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: A Lags B");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            A <= 0;
            B <= 1;

            @(posedge clk);
            A <= 1;

            repeat (2) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Significant Lead");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            A <= 1;
            repeat (3) @(posedge clk);
            B <= 1;

            repeat (2) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Idle State");
            test_num = test_num + 1;
            reset_dut();

            repeat (3) @(posedge clk);
            #1;


            #1;



            check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Post-Transition Stability");
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            A <= 1; B <= 1;
            repeat (2) @(posedge clk);


            A <= 0; B <= 0;
            repeat (2) @(posedge clk);
            #1;



            #1;




            check_outputs(0, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_detector Testbench");
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
        input expected_out_inphase;
        input expected_out_lag;
        input expected_out_lead;
        begin
            if (expected_out_inphase === (expected_out_inphase ^ out_inphase ^ expected_out_inphase) &&
                expected_out_lag === (expected_out_lag ^ out_lag ^ expected_out_lag) &&
                expected_out_lead === (expected_out_lead ^ out_lead ^ expected_out_lead)) begin
                $display("PASS");
                $display("  Outputs: out_inphase=%b, out_lag=%b, out_lead=%b",
                         out_inphase, out_lag, out_lead);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_inphase=%b, out_lag=%b, out_lead=%b",
                         expected_out_inphase, expected_out_lag, expected_out_lead);
                $display("  Got:      out_inphase=%b, out_lag=%b, out_lead=%b",
                         out_inphase, out_lag, out_lead);
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
        $dumpvars(0,A, B, clk, out_inphase, out_lag, out_lead);
    end

endmodule
