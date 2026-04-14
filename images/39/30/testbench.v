`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg reset;
    reg shift_left;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .shift_left(shift_left),
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
            data_in = 16'h0;
            shift_left = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Left Full (16 bits of 1)", test_num);
            reset_dut();
            shift_left = 1;
            data_in = 16'h0001;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Right Full (16 bits of 1)", test_num);
            reset_dut();
            shift_left = 0;
            data_in = 16'h0001;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Left Partial (8 bits of 1)", test_num);
            reset_dut();
            shift_left = 1;
            data_in = 16'h0001;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Right Partial (8 bits of 1)", test_num);
            reset_dut();
            shift_left = 0;
            data_in = 16'h0001;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Left Sequence (4 ones, 4 zeros)", test_num);
            reset_dut();
            shift_left = 1;

            data_in = 16'h0001;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                #1;
            end

            data_in = 16'h0000;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(16'h00F0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Right Sequence (4 ones, 4 zeros)", test_num);
            reset_dut();
            shift_left = 0;

            data_in = 16'h0001;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                #1;
            end

            data_in = 16'h0000;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(16'h0F00);
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
        $dumpvars(0,clk, data_in, reset, shift_left, data_out);
    end

endmodule
