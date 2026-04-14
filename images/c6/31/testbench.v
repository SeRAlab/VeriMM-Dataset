`timescale 1ns/1ps

module binary_counter_tb;

    // Testbench signals (sequential circuit)
    reg RST;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter dut (
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        RST = 0;
        forever #5 RST = ~RST;
    end

        task reset_dut;

        begin
            RST = 0;
            #12;
            RST = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase %03d: Post-Reset Initialization", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase %03d: Basic Increment", test_num);
            reset_dut();
            repeat(1) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase %03d: Count to 10", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase %03d: Overflow Wrap-around", test_num);
            reset_dut();
            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running testcase %03d: Asynchronous Reset Mid-Cycle", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #2;
            RST = 0;
            #1;

            #1;


            check_outputs(4'b0000);
            RST = 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter Testbench");
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,RST, Q);
    end

endmodule
