`timescale 1ns/1ps

module bidir_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg shift_dir;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bidir_shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .shift_dir(shift_dir),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            data_in = 8'h00;
            shift_dir = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Shift Left 8 times (Fill with 1s)", test_num);
            reset_dut();
            shift_dir = 1;
            data_in = 8'h01;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Shift Right 8 times (Fill with 1s)", test_num);
            reset_dut();
            shift_dir = 0;
            data_in = 8'h80;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Shift Left 4 times (Result: 0F)", test_num);
            reset_dut();
            shift_dir = 1;
            data_in = 8'h01;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Shift Right 4 times (Result: F0)", test_num);
            reset_dut();
            shift_dir = 0;
            data_in = 8'h80;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Transition Shift Dir (Left 4 ones, Right 2 zeros)", test_num);
            reset_dut();

            shift_dir = 1; data_in = 8'h01;
            repeat(4) @(posedge clk);

            shift_dir = 0; data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating Bit Pattern Left Shift", test_num);
            reset_dut();
            shift_dir = 1;
            data_in = 8'h01; @(posedge clk);
            data_in = 8'h00; @(posedge clk);
            data_in = 8'h01; @(posedge clk);
            data_in = 8'h00; @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bidir_shift_register Testbench");
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, reset, shift_dir, data_out);
    end

endmodule
