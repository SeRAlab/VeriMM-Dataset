`timescale 1ns/1ps

module shift_reg_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load_en;
    reg rst;
    reg shift_en;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .load_en(load_en),
        .rst(rst),
        .shift_en(shift_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load_en = 0;
            shift_en = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parallel Load 0xACE0", test_num);
            reset_dut();
            data_in = 16'hACE0;
            load_en = 1;
            @(posedge clk);
            #1;
            load_en = 0;
            #1;

            check_outputs(16'hACE0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Right Shift", test_num);
            reset_dut();

            data_in = 16'h0002;
            load_en = 1;
            @(posedge clk);
            #1;

            load_en = 0;
            shift_en = 1;
            @(posedge clk);
            #1;
            shift_en = 0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Shifts (4 times)", test_num);
            reset_dut();

            data_in = 16'hF000;
            load_en = 1;
            @(posedge clk);
            #1;

            load_en = 0;
            shift_en = 1;
            repeat(4) @(posedge clk);
            #1;
            shift_en = 0;
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Priority Check (Load over Shift)", test_num);
            reset_dut();

            data_in = 16'hAAAA;
            load_en = 1;
            @(posedge clk);
            #1;

            data_in = 16'h5555;
            load_en = 1;
            shift_en = 1;
            @(posedge clk);
            #1;
            shift_en = 0;
            load_en = 0;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Persistence", test_num);
            reset_dut();

            data_in = 16'h1234;
            load_en = 1;
            @(posedge clk);
            #1;

            load_en = 0;
            shift_en = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift 16 bits to Zero", test_num);
            reset_dut();

            data_in = 16'h8000;
            load_en = 1;
            @(posedge clk);
            #1;

            load_en = 0;
            shift_en = 1;
            repeat(16) @(posedge clk);
            #1;
            shift_en = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite with Zero", test_num);
            reset_dut();

            data_in = 16'hFFFF;
            load_en = 1;
            @(posedge clk);
            #1;

            data_in = 16'h0000;
            load_en = 1;
            @(posedge clk);
            #1;
            load_en = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_16bit Testbench");
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
        $dumpvars(0,clk, data_in, load_en, rst, shift_en, data_out);
    end

endmodule
