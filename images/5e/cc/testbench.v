`timescale 1ns/1ps

module fibonacci_lfsr_6_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [5:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fibonacci_lfsr_6 dut (
        .clk(clk),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            #10;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking reset state...", test_num);
            reset_dut();

            #1;


            check_outputs(6'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: 1 clock cycle transition...", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h3E);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: 5 clock cycles (approaching tap change)...", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(6'h20);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: 6 clock cycles (feedback bit becomes 1)...", test_num);
            reset_dut();
            repeat(6) @(posedge clk);
            #1;

            #1;


            check_outputs(6'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: 10 clock cycles...", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(6'h11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Full sequence period (63 cycles)...", test_num);
            reset_dut();
            repeat(63) @(posedge clk);
            #1;

            #1;


            check_outputs(6'h3F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: One cycle before wrap-around (62 cycles)...", test_num);
            reset_dut();
            repeat(62) @(posedge clk);
            #1;


            #1;



            check_outputs(6'h1F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fibonacci_lfsr_6 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [5:0] expected_Q;
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
        $dumpvars(0,clk, rst_n, Q);
    end

endmodule
