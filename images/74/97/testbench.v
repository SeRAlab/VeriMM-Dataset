`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    reg serial_in;
    wire [3:0] reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .reset_n(reset_n),
        .serial_in(serial_in),
        .reg_out(reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            serial_in = 0;
            #15;
            reset_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in 1, 1, 0, 1", test_num);
            reset_dut();

            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 0;
            @(posedge clk) serial_in = 1;
            @(negedge clk);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fill with all ones", test_num);
            reset_dut();
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 1;
            @(negedge clk);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify reset state (all zeros)", test_num);
            reset_dut();

            @(negedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Over-shifting 6 bits (Sequence: 1,1,0,0,1,0)", test_num);
            reset_dut();
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 0;
            @(posedge clk) serial_in = 0;
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 0;


            @(negedge clk);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in alternating 1010", test_num);
            reset_dut();
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 0;
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 0;
            @(negedge clk);
            #1;

            check_outputs(4'b0101);
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
        input [3:0] expected_reg_out;
        begin
            if (expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out)) begin
                $display("PASS");
                $display("  Outputs: reg_out=%h",
                         reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_out=%h",
                         expected_reg_out);
                $display("  Got:      reg_out=%h",
                         reg_out);
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
        $dumpvars(0,clk, reset_n, serial_in, reg_out);
    end

endmodule
