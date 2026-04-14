`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] P;
    reg clk;
    reg load;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .P(P),
        .clk(clk),
        .load(load),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            P = 4'b0000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Load 4'b1011, check LSB...");
            reset_dut();
            P = 4'b1011;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load 4'b1011, shift 1, check Q...");
            reset_dut();
            P = 4'b1011;
            load = 1;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Load 4'b1011, shift 2, check Q...");
            reset_dut();
            P = 4'b1011;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Load 4'b1011, shift 3, check Q...");
            reset_dut();
            P = 4'b1011;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Load 4'b1100, check LSB...");
            reset_dut();
            P = 4'b1100;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Load 4'b1100, shift 2, check Q...");
            reset_dut();
            P = 4'b1100;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Load 4'b0000, check Q...");
            reset_dut();
            P = 4'b0000;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Load 4'b1111, shift 4, check Q...");
            reset_dut();
            P = 4'b1111;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
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
        $dumpvars(0,P, clk, load, Q);
    end

endmodule
