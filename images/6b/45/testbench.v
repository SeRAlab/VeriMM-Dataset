`timescale 1ns/1ps

module register_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg clk;
    reg load;
    reg reset;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register dut (
        .D(D),
        .clk(clk),
        .load(load),
        .reset(reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            D = 4'h0;
            #12;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Data with Load=1 (D=4'hA)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            load = 1;
            D = 4'hA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Load=0 inhibits writing (D=4'hF)", test_num);
            reset_dut();

            @(posedge clk);
            #1; load = 1; D = 4'h5;
            @(posedge clk);
            #1;
            load = 0;
            D = 4'hF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Check Asynchronous Reset during operation", test_num);
            reset_dut();

            @(posedge clk);
            #1; load = 1; D = 4'hC;
            @(posedge clk);
            #1;

            #3;
            reset = 1;
            #1;
            #1;

            check_outputs(4'h0);
            reset = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Maximum Value (4'hF)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            load = 1;
            D = 4'hF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Successive Loads", test_num);
            reset_dut();
            @(posedge clk);
            #1; load = 1; D = 4'h1;
            @(posedge clk);
            #1; D = 4'h2;
            @(posedge clk);
            #1; D = 4'h3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register Testbench");
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
        $dumpvars(0,D, clk, load, reset, Q);
    end

endmodule
