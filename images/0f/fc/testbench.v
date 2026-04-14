`timescale 1ns/1ps

module shift_register_tb;

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
    shift_register dut (
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
        reset = 1;
        data_in = 8'h00;
        shift_dir = 0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Verification", test_num);
        reset_dut();

        @(posedge clk);
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Left Shift 8 bits (All 1s)", test_num);
        reset_dut();
        shift_dir = 0;
        data_in = 8'h01;
        repeat(8) @(posedge clk);
        #1 #1;
 check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Right Shift 8 bits (All 1s)", test_num);
        reset_dut();
        shift_dir = 1;
        data_in = 8'h80;
        repeat(8) @(posedge clk);
        #1 #1;
 check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    integer i;
    reg [7:0] pattern;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Left Shift Pattern 10101010 (0xAA)", test_num);
        reset_dut();
        shift_dir = 0;
        pattern = 8'hAA;

        for (i = 7; i >= 0; i = i - 1) begin
            data_in[0] = pattern[i];
            @(posedge clk);
        end
        #1 #1;
 check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    integer i;
    reg [7:0] pattern;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Right Shift Pattern 01010101 (0x55)", test_num);
        reset_dut();
        shift_dir = 1;
        pattern = 8'h55;

        for (i = 0; i <= 7; i = i + 1) begin
            data_in[7] = pattern[i];
            @(posedge clk);
        end
        #1 #1;
 check_outputs(8'h55);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Direction Change (Left 4 bits, then Right 4 bits)", test_num);
        reset_dut();


        shift_dir = 0;
        data_in[0] = 1'b1;
        repeat(4) @(posedge clk);


        shift_dir = 1;
        data_in[7] = 1'b0;
        repeat(4) @(posedge clk);

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
