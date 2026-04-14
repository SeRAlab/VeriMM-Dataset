`timescale 1ns/1ps

module shift_register_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg reset;
    reg shift_left;
    reg shift_right;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_32bit dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .shift_left(shift_left),
        .shift_right(shift_right),
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
        shift_left = 0;
        shift_right = 0;
        data_in = 32'h0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Synchronous Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Shift Left Single Bit", test_num);
        reset_dut();
        shift_left = 1;
        data_in = 32'hFFFFFFFF;
        @(posedge clk);
        #1 shift_left = 0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Shift Left 8 Bits", test_num);
        reset_dut();
        repeat(8) begin
            shift_left = 1;
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
        end
        #1 shift_left = 0;
        #1;

        check_outputs(32'h000000FF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Shift Right Check", test_num);
        reset_dut();

        repeat(4) begin
            shift_left = 1; data_in = 32'hFFFFFFFF; @(posedge clk);
        end

        shift_left = 0;
        shift_right = 1;
        data_in = 32'h00000000;
        @(posedge clk);
        #1 shift_right = 0;
        #1;

        check_outputs(32'h00000007);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Hold Value Check", test_num);
        reset_dut();

        shift_left = 1; data_in = 32'hFFFFFFFF; @(posedge clk);

        #1 shift_left = 0; shift_right = 0;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(32'h00000001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Fill 32-bit Register Left", test_num);
        reset_dut();
        repeat(32) begin
            shift_left = 1; data_in = 32'hFFFFFFFF; @(posedge clk);
        end
        #1 shift_left = 0;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Shift Right 32-bit Fill", test_num);
        reset_dut();
        repeat(32) begin
            shift_right = 1; data_in = 32'hFFFFFFFF; @(posedge clk);
        end
        #1 shift_right = 0;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Reset Priority over Shift", test_num);
        reset_dut();

        reset = 1;
        shift_left = 1;
        data_in = 32'hFFFFFFFF;
        @(posedge clk);
        #1 reset = 0; shift_left = 0;
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
        $display("shift_register_32bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, reset, shift_left, shift_right, data_out);
    end

endmodule
