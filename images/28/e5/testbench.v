`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg reset;
    reg shift;
    reg shift_right;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .shift(shift),
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
        load = 0;
        shift = 0;
        shift_right = 0;
        data_in = 16'h0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset Register", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Parallel Load 0xAAAA", test_num);
        reset_dut();
        data_in = 16'hAAAA;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Left Once", test_num);
        reset_dut();

        data_in = 16'h0001;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        shift = 1;
        @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Right Once", test_num);
        reset_dut();

        data_in = 16'h8000;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        shift_right = 1;
        @(posedge clk);
        #1 shift_right = 0;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Left 4 bits", test_num);
        reset_dut();
        data_in = 16'h000F;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift = 1;
        repeat(4) @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(16'h00F0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Right 4 bits", test_num);
        reset_dut();
        data_in = 16'hF000;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift_right = 1;
        repeat(4) @(posedge clk);
        #1 shift_right = 0;
        #1;

        check_outputs(16'h0F00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load vs Shift Priority", test_num);
        reset_dut();
        data_in = 16'h5555;
        load = 1;
        @(posedge clk);
        #1;

        data_in = 16'hABCD;
        load = 1;
        shift = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift = 0;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Data Retention", test_num);
        reset_dut();
        data_in = 16'h1234;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        repeat(5) @(posedge clk);
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Left MSB Loss", test_num);
        reset_dut();
        data_in = 16'h8001;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift = 1;
        @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Right LSB Loss", test_num);
        reset_dut();
        data_in = 16'h8001;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift_right = 1;
        @(posedge clk);
        #1 shift_right = 0;
        #1;

        check_outputs(16'h4000);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        $dumpvars(0,clk, data_in, load, reset, shift, shift_right, data_out);
    end

endmodule
