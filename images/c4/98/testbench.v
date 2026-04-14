`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg shift_dir;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .in(in),
        .shift_dir(shift_dir),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 4'b0000;
            shift_dir = 0;
            repeat (4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Left Shift (1011)", test_num);
            reset_dut();
            shift_dir = 0;
            in = 4'b1111; @(posedge clk);
            in = 4'b0000; @(posedge clk);
            in = 4'b1111; @(posedge clk);
            in = 4'b1111; @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Right Shift (1001)", test_num);
            reset_dut();
            shift_dir = 1;
            in = 4'b1111; @(posedge clk);
            in = 4'b0000; @(posedge clk);
            in = 4'b0000; @(posedge clk);
            in = 4'b1111; @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fill All Ones (Left)", test_num);
            reset_dut();
            shift_dir = 0;
            in = 4'b1111;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fill 1s then Right Shift 0s", test_num);
            reset_dut();

            shift_dir = 0; in = 4'b1111; repeat (4) @(posedge clk);

            shift_dir = 1; in = 4'b0000; repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixed Direction", test_num);
            reset_dut();

            shift_dir = 0;
            in = 4'b1111; @(posedge clk);
            in = 4'b1111; @(posedge clk);

            shift_dir = 1;
            in = 4'b1111; @(posedge clk);
            in = 4'b0000; @(posedge clk);

            #1;
            #1;

            check_outputs(4'b0100);
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
        $dumpvars(0,clk, in, shift_dir, out);
    end

endmodule
