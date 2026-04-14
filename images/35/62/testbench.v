`timescale 1ns/1ps

module vco_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] ctrl;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vco dut (
        .clk(clk),
        .ctrl(ctrl),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ctrl = 3'd0;

            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: 1MHz - Checking toggle after 500ns");
            test_num = test_num + 1;
            reset_dut();

            ctrl = 3'd0;


            repeat(51) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: 1MHz - Checking toggle after 1000ns");
            test_num = test_num + 1;
            reset_dut();

            ctrl = 3'd0;


            repeat(101) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: 10MHz - Checking toggle after 50ns");
            test_num = test_num + 1;
            reset_dut();

            ctrl = 3'd5;


            repeat(6) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: 10MHz - Checking toggle after 100ns");
            test_num = test_num + 1;
            reset_dut();

            ctrl = 3'd5;


            repeat(11) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: 10MHz - Checking 2.5 periods (250ns)");
            test_num = test_num + 1;
            reset_dut();

            ctrl = 3'd5;


            repeat(26) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vco Testbench");
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
        $dumpvars(0,clk, ctrl, out);
    end

endmodule
