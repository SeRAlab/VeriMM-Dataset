`timescale 1ns/1ps

module fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg x;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            x = 0;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            x = 1;
            @(posedge clk);
            #1 x = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            x = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 x = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            x = 1;
            @(posedge clk);
            #1 x = 0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            x = 1;
            @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            x = 1;
            @(posedge clk);
            #1 x = 0;
            @(posedge clk);
            #1 x = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            x = 1;
            @(posedge clk);
            x = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm Testbench");
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
        input expected_z;
        begin
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%b",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%b",
                         expected_z);
                $display("  Got:      z=%b",
                         z);
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
        $dumpvars(0,clk, reset, x, z);
    end

endmodule
