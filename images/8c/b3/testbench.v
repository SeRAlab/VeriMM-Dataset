`timescale 1ns/1ps

module shift_reg_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg shift_in;
    wire [31:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_32bit dut (
        .clk(clk),
        .rst(rst),
        .shift_in(shift_in),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            shift_in = 0;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Shift in single '1'", test_num);
            reset_dut();
            shift_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Shift in 8-bit pattern (0xA5)", test_num);
            reset_dut();
            pattern = 8'hA5;
            for (i = 7; i >= 0; i = i - 1) begin
                shift_in = pattern[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(32'h000000A5);
        end
        endtask

    task testcase004;

        reg [31:0] data;
        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Fill 32-bit register (0xDEADBEEF)", test_num);
            reset_dut();
            data = 32'hDEADBEEF;
            for (i = 31; i >= 0; i = i - 1) begin
                shift_in = data[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase005;

        reg [31:0] data;
        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: 33-bit shift (Check overflow)", test_num);
            reset_dut();


            shift_in = 1;
            @(posedge clk);
            #1;


            shift_in = 0;
            repeat(32) begin
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_32bit Testbench");
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
        input [31:0] expected_shift_out;
        begin
            if (expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: shift_out=%h",
                         shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_out=%h",
                         expected_shift_out);
                $display("  Got:      shift_out=%h",
                         shift_out);
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
        $dumpvars(0,clk, rst, shift_in, shift_out);
    end

endmodule
