`timescale 1ns/1ps

module reset_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg sync_rst;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reset_controller dut (
        .clk(clk),
        .rst_n(rst_n),
        .sync_rst(sync_rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 1'b1;
            sync_rst = 1'b0;
            #5;
            rst_n = 1'b0;
            #10;
            rst_n = 1'b1;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %03d: Active low reset (rst_n)", test_num);

            rst_n = 1'b0;
            #2;
            #1;

            check_outputs(1'b0);
            rst_n = 1'b1;
            #5;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %03d: Synchronous reset (sync_rst)", test_num);
            @(negedge clk);
            sync_rst = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
            sync_rst = 1'b0;
            #5;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %03d: Simultaneous reset priority", test_num);

            rst_n = 1'b0;
            sync_rst = 1'b1;
            #2;
            #1;

            check_outputs(1'b0);
            rst_n = 1'b1;
            sync_rst = 1'b0;
            #5;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %03d: Hold value stability", test_num);
            rst_n = 1'b1;
            sync_rst = 1'b0;

            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %03d: Sync reset edge sensitivity", test_num);
            @(negedge clk);
            sync_rst = 1'b1;
            #2;


            #1;



            check_outputs(1'b0);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
            sync_rst = 1'b0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reset_controller Testbench");
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
        $dumpvars(0,clk, rst_n, sync_rst, out);
    end

endmodule
