`timescale 1ns/1ps

module circular_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] data_in;
    reg reset;
    wire [9:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    circular_shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [9:0] initial_val;
        begin
            reset = 1;
            data_in = initial_val;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset to Zero", test_num);
            reset_dut(10'b1111111111);

            #1;


            check_outputs(10'b0000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Left - 1 bit shift", test_num);

            reset_dut(10'b1000000000);
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'b0000000001);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Left - Full 10-bit rotation", test_num);
            reset_dut(10'b1011001110);
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(10'b1011001110);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Left - 5 bit shift", test_num);
            reset_dut(10'b1111100000);
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(10'b0000011111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Left - All ones pattern", test_num);
            reset_dut(10'b1111111111);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'b1111111111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("circular_shift_register Testbench");
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
        input [9:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, reset, data_out);
    end

endmodule
