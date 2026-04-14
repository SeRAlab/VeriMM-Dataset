`timescale 1ns/1ps

module pipo_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg load;
    reg shift;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipo_shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift(shift),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        load = 0;
        shift = 0;
        data_in = 5'b00000;
        @(posedge clk);
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        data_in = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Parallel Load 5'b10101", test_num);
        reset_dut();
        data_in = 5'b10101;
        load = 1;
        shift = 0;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(5'b10101);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Single Right Shift", test_num);
        reset_dut();

        data_in = 5'b10000;
        load = 1;
        @(posedge clk);
        #1;

        load = 0;
        shift = 1;
        @(posedge clk);
        #1;
        shift = 0;
        #1;

        check_outputs(5'b01000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Double Right Shift", test_num);
        reset_dut();

        data_in = 5'b11000;
        load = 1;
        @(posedge clk);
        #1;

        load = 0;
        shift = 1;
        @(posedge clk);

        @(posedge clk);
        #1;
        shift = 0;
        #1;

        check_outputs(5'b00110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Data Retention (No Load/No Shift)", test_num);
        reset_dut();

        data_in = 5'b01101;
        load = 1;
        @(posedge clk);
        #1;

        load = 0;
        shift = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(5'b01101);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Load Priority Over Shift", test_num);
        reset_dut();

        data_in = 5'b11111;
        load = 1;
        shift = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift = 0;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Shift Right 5 times (Emptying Register)", test_num);
        reset_dut();

        data_in = 5'b10000;
        load = 1;
        @(posedge clk);
        #1;

        load = 0;
        shift = 1;
        repeat(5) @(posedge clk);
        #1;
        shift = 0;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipo_shift_register Testbench");
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
        input [4:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, shift, data_out);
    end

endmodule
