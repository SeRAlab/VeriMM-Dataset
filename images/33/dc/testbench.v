`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg mode;
    reg reset;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .mode(mode),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            mode = 0;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Left Shift (16 bits of 1s)", test_num);
            reset_dut();

            mode = 0;
            data_in = 16'hFFFF;

            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Right Shift (16 bits of 1s)", test_num);
            reset_dut();

            mode = 1;
            data_in = 16'hFFFF;

            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Left Shift Alternating Pattern (1010...)", test_num);
            reset_dut();

            mode = 0;



            for (i = 0; i < 8; i = i + 1) begin
                data_in = 16'hFFFF; @(posedge clk); #1;
                data_in = 16'h0000; @(posedge clk); #1;
            end

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right Shift Alternating Pattern (0101...)", test_num);
            reset_dut();

            mode = 1;



            for (i = 0; i < 8; i = i + 1) begin
                data_in = 16'hFFFF; @(posedge clk); #1;
                data_in = 16'h0000; @(posedge clk); #1;
            end

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Verification during operation", test_num);
            reset_dut();


            mode = 0;
            data_in = 16'hFFFF;
            repeat(8) @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Switching Directions (Left then Right)", test_num);
            reset_dut();


            mode = 0;
            data_in = 16'hFFFF;
            repeat(8) @(posedge clk);
            #1;



            mode = 1;
            data_in = 16'h0000;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h000F);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, mode, reset, data_out);
    end

endmodule
