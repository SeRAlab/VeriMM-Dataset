`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d_in;
    reg rst;
    reg shift_dir;
    wire [15:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .d_in(d_in),
        .rst(rst),
        .shift_dir(shift_dir),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            d_in = 0;
            shift_dir = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left (1 bit)", test_num);
            reset_dut();
            d_in = 16'hFFFF;
            shift_dir = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right (1 bit)", test_num);
            reset_dut();
            d_in = 16'hFFFF;
            shift_dir = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-cycle Shift Left (1011)", test_num);
            reset_dut();


            d_in = 16'hFFFF; shift_dir = 0; @(posedge clk); #1;

            d_in = 16'h0000; shift_dir = 0; @(posedge clk); #1;

            d_in = 16'hFFFF; shift_dir = 0; @(posedge clk); #1;

            d_in = 16'hFFFF; shift_dir = 0; @(posedge clk); #1;

            #1;


            check_outputs(16'h000B);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-cycle Shift Right (1101)", test_num);
            reset_dut();


            d_in = 16'hFFFF; shift_dir = 1; @(posedge clk); #1;

            d_in = 16'hFFFF; shift_dir = 1; @(posedge clk); #1;

            d_in = 16'h0000; shift_dir = 1; @(posedge clk); #1;

            d_in = 16'hFFFF; shift_dir = 1; @(posedge clk); #1;

            #1;


            check_outputs(16'hB000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Direction Toggle", test_num);
            reset_dut();


            d_in = 16'hFFFF; shift_dir = 0; @(posedge clk); #1;

            d_in = 16'hFFFF; shift_dir = 0; @(posedge clk); #1;

            d_in = 16'hFFFF; shift_dir = 1; @(posedge clk); #1;

            #1;


            check_outputs(16'h8001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill Register (16 Left Shifts)", test_num);
            reset_dut();

            repeat(16) begin
                d_in = 16'hFFFF;
                shift_dir = 0;
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(16'hFFFF);
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
        input [15:0] expected_d_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
        $dumpvars(0,clk, d_in, rst, shift_dir, d_out);
    end

endmodule
