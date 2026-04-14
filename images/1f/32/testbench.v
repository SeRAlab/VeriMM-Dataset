`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_data;
    reg rst;
    reg shift_left;
    wire [7:0] register_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .input_data(input_data),
        .rst(rst),
        .shift_left(shift_left),
        .register_out(register_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_data = 8'h00;
            shift_left = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Verification", test_num);
            reset_dut();

            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Shift Left 8 times (Serial In = 1)", test_num);
            reset_dut();
            shift_left = 1;
            input_data = 8'hFF;
            repeat (8) @(posedge clk);
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Shift Right 8 times (Serial In = 1)", test_num);
            reset_dut();
            shift_left = 0;
            input_data = 8'hFF;
            repeat (8) @(posedge clk);
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Shift Left Alternating Pattern", test_num);
            reset_dut();
            shift_left = 1;
            repeat (4) begin
                input_data = 8'h00; @(posedge clk);
                input_data = 8'hFF; @(posedge clk);
            end
            #1 #1;
 check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Shift Right Alternating Pattern", test_num);
            reset_dut();
            shift_left = 0;
            repeat (4) begin
                input_data = 8'h00; @(posedge clk);
                input_data = 8'hFF; @(posedge clk);
            end
            #1 #1;
 check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Shift Left 4 times, then Shift Right 2 times", test_num);
            reset_dut();

            shift_left = 1;
            input_data = 8'hFF;
            repeat (4) @(posedge clk);


            shift_left = 0;
            input_data = 8'h00;
            repeat (2) @(posedge clk);

            #1 #1;
 check_outputs(8'h03);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Shift Left Clear Through", test_num);
            reset_dut();

            shift_left = 1;
            input_data = 8'hFF;
            repeat (8) @(posedge clk);

            input_data = 8'h00;
            repeat (8) @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
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
        input [7:0] expected_register_out;
        begin
            if (expected_register_out === (expected_register_out ^ register_out ^ expected_register_out)) begin
                $display("PASS");
                $display("  Outputs: register_out=%h",
                         register_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: register_out=%h",
                         expected_register_out);
                $display("  Got:      register_out=%h",
                         register_out);
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
        $dumpvars(0,clk, input_data, rst, shift_left, register_out);
    end

endmodule
