`timescale 1ns/1ps

module serial2parallel_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg rst_n;
    wire [3:0] dout;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serial2parallel dut (
        .clk(clk),
        .din(din),
        .rst_n(rst_n),
        .dout(dout),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            din = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input sequence 1, 0, 1, 0", test_num);
            reset_dut();
            @(negedge clk) din = 1;
            @(negedge clk) din = 0;
            @(negedge clk) din = 1;
            @(negedge clk) din = 0;
            @(posedge clk);
            #1; #1;
 check_outputs(4'b1010, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input sequence 1, 1, 1, 1", test_num);
            reset_dut();
            @(negedge clk) din = 1;
            @(negedge clk) din = 1;
            @(negedge clk) din = 1;
            @(negedge clk) din = 1;
            @(posedge clk);
            #1; #1;
 check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input sequence 0, 0, 0, 0", test_num);
            reset_dut();
            @(negedge clk) din = 0;
            @(negedge clk) din = 0;
            @(negedge clk) din = 0;
            @(negedge clk) din = 0;
            @(posedge clk);
            #1; #1;
 check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input sequence 0, 1, 1, 0", test_num);
            reset_dut();
            @(negedge clk) din = 0;
            @(negedge clk) din = 1;
            @(negedge clk) din = 1;
            @(negedge clk) din = 0;
            @(posedge clk);
            #1; #1;
 check_outputs(4'b0110, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Incomplete sequence (2 bits only)", test_num);
            reset_dut();
            @(negedge clk) din = 1;
            @(negedge clk) din = 1;
            @(posedge clk);
            #1; #1;
 check_outputs(dout, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serial2parallel Testbench");
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
        input [3:0] expected_dout;
        input expected_valid_out;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, valid_out=%b",
                         dout, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, valid_out=%b",
                         expected_dout, expected_valid_out);
                $display("  Got:      dout=%h, valid_out=%b",
                         dout, valid_out);
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
        $dumpvars(0,clk, din, rst_n, dout, valid_out);
    end

endmodule
